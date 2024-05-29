USE tpch;

DROP TABLE IF EXISTS sample_table2;

CREATE TABLE sample_table2 (sample_key bigint, sample_status STRING) USING delta LOCATION 's3a://tpch/sample_table2';


SELECT
    *
FROM
    sample_table2;

INSERT INTO
    sample_table2
VALUES
    (1, 'hello');

SELECT
    *
FROM
    sample_table2;

INSERT INTO
    sample_table2
VALUES
    (1, 'hello');

SELECT
    *
FROM
    sample_table2;

-- inserting values from another table
INSERT INTO
    sample_table2
SELECT
    nationkey,
    name
FROM
    nation;

SELECT
    *
FROM
    sample_table2;

-- deletes all the rows in sample_table2, but table still present
-- In order to delete rows we need to set the table to be transactional, this supports sql transaction 
-- deletes (single row deletes) as opposed to general delete of entire paritions ( as allowed in HIVE)

ALTER TABLE
    sample_table2
SET
    TBLPROPERTIES ('transactional' = 'true');

DELETE FROM
    sample_table2;

-- drops the table entirely, the table will need to be re-created
DROP TABLE sample_table2;

