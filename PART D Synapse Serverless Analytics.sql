USE SmartGear;

CREATE EXTERNAL DATA SOURCE smartgear_data_source
WITH (
    LOCATION = 'https://smartgearassignment.dfs.core.windows.net/synapse-assignment'
);

-- 3. Define CSV file format (no IF)
-- Ignore 'already exists' error once if it appears
CREATE EXTERNAL FILE FORMAT CsvFormat
WITH (
    FORMAT_TYPE = DELIMITEDTEXT,
    FORMAT_OPTIONS (
        FIELD_TERMINATOR = ',',
        STRING_DELIMITER = '"',
        FIRST_ROW = 2  -- skip header row
    )
);


