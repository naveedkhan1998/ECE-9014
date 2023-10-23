-- register_postgres.sql
INSERT INTO
    servers (
        srvhost,
        srvport,
        srvmaintenance_db,
        srvusername,
        srvpassword,
        srvsslmode,
        srvsslcompression,
        srvsslcert,
        srvsslkey,
        srvsslrootcert,
        srvsslcrl,
        srvsslcapath,
        srvsslcipher,
        srvoptions,
        srvservice
    )
VALUES
    (
        'postgres',
        '5432',
        'postgres',
        'postgres',
        'postgres',
        'prefer',
        False,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        'ECE9014'
    );