CREATE TABLE  SBI_COMMUNITY(
  COMMUNITY_ID INTEGER NOT NULL,
  NAME VARCHAR(200) NOT NULL,
  DESCRIPTION VARCHAR(350) DEFAULT NULL,
  OWNER INTEGER NOT NULL,
  FUNCT_CODE VARCHAR(40) DEFAULT NULL,
  CREATION_DATE timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  LAST_CHANGE_DATE timestamp NOT NULL  DEFAULT CURRENT_TIMESTAMP,
  USER_IN VARCHAR(100) NOT NULL,
  USER_UP VARCHAR(100) DEFAULT NULL,
  USER_DE VARCHAR(100) DEFAULT NULL,
  TIME_IN timestamp NOT NULL,
  TIME_UP timestamp NULL DEFAULT NULL,
  TIME_DE timestamp NULL DEFAULT NULL,
  SBI_VERSION_IN VARCHAR(10) DEFAULT NULL,
  SBI_VERSION_UP VARCHAR(10) DEFAULT NULL,
  SBI_VERSION_DE VARCHAR(10) DEFAULT NULL,
  META_VERSION VARCHAR(100) DEFAULT NULL,
  ORGANIZATION VARCHAR(20) DEFAULT NULL,
  PRIMARY KEY (COMMUNITY_ID)
);

CREATE TABLE SBI_COMMUNITY_USERS (
  COMMUNITY_ID INTEGER NOT NULL,
  USER_ID VARCHAR(100) NOT NULL,
  CREATION_DATE timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  LAST_CHANGE_DATE timestamp NOT NULL  DEFAULT CURRENT_TIMESTAMP,
  USER_IN VARCHAR(100) NOT NULL,
  USER_UP VARCHAR(100) DEFAULT NULL,
  USER_DE VARCHAR(100) DEFAULT NULL,
  TIME_IN timestamp NOT NULL,
  TIME_UP timestamp NULL DEFAULT NULL,
  TIME_DE timestamp NULL DEFAULT NULL,
  SBI_VERSION_IN VARCHAR(10) DEFAULT NULL,
  SBI_VERSION_UP VARCHAR(10) DEFAULT NULL,
  SBI_VERSION_DE VARCHAR(10) DEFAULT NULL,
  META_VERSION VARCHAR(100) DEFAULT NULL,
  ORGANIZATION VARCHAR(20) DEFAULT NULL,
  PRIMARY KEY (COMMUNITY_ID,USER_ID),
  CONSTRAINT FK_COMMUNITY FOREIGN KEY (COMMUNITY_ID) REFERENCES SBI_COMMUNITY (COMMUNITY_ID) ON DELETE NO ACTION ON UPDATE NO ACTION
) ;


ALTER TABLE SBI_OBJECTS ADD COLUMN PREVIEW_FILE VARCHAR(100);

INSERT INTO SBI_USER_FUNC (USER_FUNCT_ID, NAME, DESCRIPTION, USER_IN, TIME_IN)
    VALUES ((SELECT next_val FROM hibernate_sequences WHERE sequence_name = 'SBI_USER_FUNC'), 
    'MeasuresCatalogueManagement','MeasuresCatalogueManagement', 'server', current_timestamp);
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_USER_FUNC';

INSERT INTO SBI_ROLE_TYPE_USER_FUNC (ROLE_TYPE_ID, USER_FUNCT_ID)
    VALUES ((SELECT VALUE_ID FROM SBI_DOMAINS WHERE VALUE_CD = 'ADMIN' AND DOMAIN_CD = 'ROLE_TYPE'), 
    (SELECT USER_FUNCT_ID FROM SBI_USER_FUNC WHERE NAME = 'MeasuresCatalogueManagement'));
commit;

INSERT INTO SBI_ROLE_TYPE_USER_FUNC (ROLE_TYPE_ID, USER_FUNCT_ID)
    VALUES ((SELECT VALUE_ID FROM SBI_DOMAINS WHERE VALUE_CD = 'ADMIN' AND DOMAIN_CD = 'ROLE_TYPE'), 
    (SELECT USER_FUNCT_ID FROM SBI_USER_FUNC WHERE NAME = 'CreateWorksheetFromDatasetUserFunctionality'));
INSERT INTO SBI_ROLE_TYPE_USER_FUNC (ROLE_TYPE_ID, USER_FUNCT_ID)
    VALUES ((SELECT VALUE_ID FROM SBI_DOMAINS WHERE VALUE_CD = 'DEV_ROLE' AND DOMAIN_CD = 'ROLE_TYPE'), 
    (SELECT USER_FUNCT_ID FROM SBI_USER_FUNC WHERE NAME = 'CreateWorksheetFromDatasetUserFunctionality'));
INSERT INTO SBI_ROLE_TYPE_USER_FUNC (ROLE_TYPE_ID, USER_FUNCT_ID)
    VALUES ((SELECT VALUE_ID FROM SBI_DOMAINS WHERE VALUE_CD = 'TEST_ROLE' AND DOMAIN_CD = 'ROLE_TYPE'), 
    (SELECT USER_FUNCT_ID FROM SBI_USER_FUNC WHERE NAME = 'CreateWorksheetFromDatasetUserFunctionality'));
INSERT INTO SBI_ROLE_TYPE_USER_FUNC (ROLE_TYPE_ID, USER_FUNCT_ID)
    VALUES ((SELECT VALUE_ID FROM SBI_DOMAINS WHERE VALUE_CD = 'MODEL_ADMIN' AND DOMAIN_CD = 'ROLE_TYPE'), 
    (SELECT USER_FUNCT_ID FROM SBI_USER_FUNC WHERE NAME = 'CreateWorksheetFromDatasetUserFunctionality'));
commit;

CREATE TABLE SBI_GEO_LAYERS (
  LAYER_ID INTEGER NOT NULL,
  LABEL varchar(100) NOT NULL,
  NAME varchar(100),
  DESCR varchar(100),
  LAYER_DEFINITION BYTEA NOT NULL,
  TYPE varchar(40),
  USER_IN varchar(100) NOT NULL,
  USER_UP varchar(100) DEFAULT NULL,
  USER_DE varchar(100) DEFAULT NULL,
  TIME_IN timestamp NOT NULL,
  TIME_UP timestamp NULL DEFAULT NULL,
  TIME_DE timestamp NULL DEFAULT NULL,
  SBI_VERSION_IN varchar(10) DEFAULT NULL,
  SBI_VERSION_UP varchar(10) DEFAULT NULL,
  SBI_VERSION_DE varchar(10) DEFAULT NULL,
  META_VERSION varchar(100) DEFAULT NULL,
  ORGANIZATION varchar(20) DEFAULT NULL,
  CONSTRAINT SBI_GEO_LAYERS UNIQUE (NAME, TYPE, ORGANIZATION),
  PRIMARY KEY (LAYER_ID)
) ;



INSERT into SBI_DOMAINS (VALUE_ID, VALUE_CD,VALUE_NM,DOMAIN_CD,DOMAIN_NM,VALUE_DS, USER_IN) 
values ((SELECT next_val FROM hibernate_sequences WHERE sequence_name = 'SBI_DOMAINS'),'FILE','FILE','LAYER_TYPE','Layer Type','Layer Type','');
UPDATE hibernate_sequences SET next_val = (SELECT MAX(VALUE_ID) + 1 FROM SBI_DOMAINS) WHERE sequence_name = 'SBI_DOMAINS';  

INSERT into SBI_DOMAINS (VALUE_ID, VALUE_CD,VALUE_NM,DOMAIN_CD,DOMAIN_NM,VALUE_DS, USER_IN) 
values ((SELECT next_val FROM hibernate_sequences WHERE sequence_name = 'SBI_DOMAINS'),'WFS','WFS','LAYER_TYPE','Layer Type','Layer Type','');
UPDATE hibernate_sequences SET next_val = (SELECT MAX(VALUE_ID) + 1 FROM SBI_DOMAINS) WHERE sequence_name = 'SBI_DOMAINS';  

INSERT INTO SBI_USER_FUNC (USER_FUNCT_ID, NAME, DESCRIPTION, USER_IN, TIME_IN)
    VALUES ((SELECT next_val FROM hibernate_sequences WHERE sequence_name = 'SBI_USER_FUNC'), 
    'GeoLayersManagement','GeoLayersManagement', 'server', current_timestamp);
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_USER_FUNC';

INSERT INTO SBI_ROLE_TYPE_USER_FUNC (ROLE_TYPE_ID, USER_FUNCT_ID)
    VALUES ((SELECT VALUE_ID FROM SBI_DOMAINS WHERE VALUE_CD = 'ADMIN' AND DOMAIN_CD = 'ROLE_TYPE'), 
    (SELECT USER_FUNCT_ID FROM SBI_USER_FUNC WHERE NAME = 'GeoLayersManagement'));
commit;


ALTER TABLE SBI_COMMUNITY ADD UNIQUE INDEX NAME_UNIQUE (ORGANIZATION, NAME ASC) ; 

ALTER TABLE SBI_OBJECTS ADD COLUMN IS_PUBLIC BOOLEAN DEFAULT FALSE;
UPDATE SBI_OBJECTS SET IS_PUBLIC = TRUE;

ALTER TABLE SBI_DATA_SET ADD COLUMN PERSIST_TABLE_NAME VARCHAR(50);

ALTER TABLE SBI_DATA_SET DROP COLUMN IS_FLAT_DATASET CASCADE;
ALTER TABLE SBI_DATA_SET DROP COLUMN FLAT_TABLE_NAME CASCADE;
ALTER TABLE SBI_DATA_SET DROP COLUMN DATA_SOURCE_FLAT_ID CASCADE;

INSERT INTO SBI_DOMAINS (VALUE_ID, VALUE_CD,VALUE_NM,DOMAIN_CD,DOMAIN_NM,VALUE_DS, USER_IN, TIME_IN)
	VALUES ((SELECT next_val FROM hibernate_sequences WHERE sequence_name = 'SBI_DOMAINS'),
	'Flat','SbiFlatDataSet','DATA_SET_TYPE','Data Set Type','SbiFlatDataSet', 'biadmin', current_timestamp);
update HIBERNATE_SEQUENCES set next_val = next_val+1 where  sequence_name = 'SBI_DOMAINS';
commit;

ALTER TABLE SBI_GEO_LAYERS ADD COLUMN IS_BASE_LAYER BOOLEAN DEFAULT FALSE;

ALTER TABLE SBI_DATA_SET DROP CONSTRAINT SBI_DATA_SET_PKEY;
ALTER TABLE SBI_DATA_SET ADD CONSTRAINT SBI_DATA_SET_PKEY PRIMARY KEY(DS_ID, VERSION_NUM, ORGANIZATION);

ALTER TABLE SBI_COMMUNITY ALTER owner TYPE varchar(200);
ALTER TABLE SBI_COMMUNITY  ALTER COLUMN CREATION_DATE SET DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE SBI_COMMUNITY  ALTER COLUMN LAST_CHANGE_DATE SET DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE SBI_COMMUNITY_USERS  ALTER COLUMN CREATION_DATE SET DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE SBI_COMMUNITY_USERS  ALTER COLUMN LAST_CHANGE_DATE SET DEFAULT CURRENT_TIMESTAMP;

ALTER TABLE SBI_ENGINES DROP FOREIGN KEY FK_SBI_ENGINE_3;
ALTER TABLE SBI_ENGINES DROP COLUMN DEFAULT_DS_ID;
commit;


ALTER TABLE SBI_DATA_SOURCE ADD COLUMN READ_ONLY BOOLEAN DEFAULT FALSE;
ALTER TABLE SBI_DATA_SOURCE ADD COLUMN WRITE_DEFAULT BOOLEAN DEFAULT FALSE;
commit;

ALTER TABLE SBI_DATA_SET DROP COLUMN DATA_SOURCE_PERSIST_ID;
commit;


ALTER TABLE SBI_DATA_SET DROP CONSTRAINT SBI_DATA_SET_PKEY;
ALTER TABLE SBI_DATA_SET ADD CONSTRAINT SBI_DATA_SET_PKEY PRIMARY KEY(DS_ID, VERSION_NUM, ORGANIZATION);

ALTER TABLE SBI_ENGINES DROP CONSTRAINT  FK_SBI_ENGINE_3;
ALTER TABLE SBI_ENGINES DROP COLUMN DEFAULT_DS_ID;
commit;

ALTER TABLE SBI_DATA_SOURCE ADD COLUMN READ_ONLY BIT DEFAULT 0;
ALTER TABLE SBI_DATA_SOURCE ADD COLUMN WRITE_DEFAULT BIT DEFAULT 0;
commit;

ALTER TABLE SBI_DATA_SET DROP COLUMN DATA_SOURCE_PERSIST_ID;
commit;
ALTER TABLE SBI_DATA_SET DROP COLUMN DATA_SOURCE_PERSIST_ID;
commit;

UPDATE SBI_CONFIG SET VALUE_CHECK = '' WHERE VALUE_CHECK = 'spagobi@eng.it';
commit;

ALTER TABLE SBI_SNAPSHOTS ADD COLUMN CONTENT_TYPE VARCHAR(300) DEFAULT NULL;

ALTER TABLE SBI_DATA_SET 	ADD CONSTRAINT FK_DATA_SET_CATEGORY FOREIGN KEY (CATEGORY_ID) 	   REFERENCES SBI_DOMAINS (VALUE_ID);
ALTER TABLE SBI_META_MODELS ADD CONSTRAINT FK_META_MODELS_CATEGORY FOREIGN KEY (CATEGORY_ID) REFERENCES SBI_DOMAINS (VALUE_ID);
