

RETURN "Creating Archetypes Relationships" AS `Progress`;
USING PERIODIC COMMIT 500
LOAD CSV WITH HEADERS 
FROM "file:///Model_Relationships.csv" AS line

MATCH (fromNode {drniId: toInteger(line.fromDrniId)})
MATCH (toNode {drniId: toInteger(line.toDrniId)})
WITH fromNode, toNode, line
CALL apoc.create.relationship(fromNode, line.relationshipType, {loadId: toInteger(line.loadId)}, toNode) YIELD rel
return "Done", count(rel);

USING PERIODIC COMMIT 500
LOAD CSV WITH HEADERS 
FROM "file:///Model_Relationships.csv" AS newline
MATCH (a {drniId: toInteger(newline.fromDrniId)})-[r {loadId: toInteger(newline.loadId)}]->(b {drniId: toInteger(newline.toDrniId)})
SET r.metadataPurpose = toBoolean(newline.metadataPurpose), 
r.relationshipTypeList = split(newline.relationshipTypeList, ";"), 
r.p1Create = timestamp(), 
r.p1CreateActivity = newline.p1CreateActivity, 
r.p1Latest = toBoolean(newline.p1Latest), 
r.latest = split(newline.latest, ";"),
r.primary = toBoolean(newline.primary),
r.drniId = toInteger(newline.drniId),
r.internalPurpose = toBoolean(newline.internalPurpose),
r.internalCreate = toBoolean(newline.internalCreate),
r.internalCreateActivity = newline.internalCreateActivity,
r.name = newline.name
;


															


		
