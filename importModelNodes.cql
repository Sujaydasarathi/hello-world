
RETURN "Deleting Archetypes and ArchetypeInstances" AS `Progress`;

MATCH (a) WHERE a.drniId >= 9999 DETACH DELETE a;

RETURN "Creating Archetypes and ArchetypeInstances" AS `Progress`;

USING PERIODIC COMMIT 500
LOAD CSV WITH HEADERS 
FROM "file:///Model_Nodes.csv" AS line

CREATE (:LOAD {
        loadId: toInteger(line.loadId),
		label1: line.label1,
		label2: line.label2,
		drniId: toInteger(line.drniId),
        name: line.name,
        createdDate: timestamp(),
        lastModifiedDate: timestamp(),
        hypermodelId: toInteger(line.hypermodelId),
        metamodelId: toInteger(line.metamodelId),
        archetypeId: toInteger(line.archetypeId),
        metadataPurpose: toBoolean(line.metadataPurpose),
		p1Latest: toBoolean(line.p1Latest),
        latest: split(line.latest, ";"),
		archetypeInstanceId: toInteger(line.archetypeInstanceId)
		});
		
MATCH (n:LOAD)
call apoc.create.addLabels([ id(n) ], [ n.label1, n.label2 ]) yield node
with node
remove node.label1
remove node.label2
remove node:LOAD;
