--Chiara 28/08/2010
Create table `SBI_KPI_DOCUMENTS` (
	`ID_KPI_DOC` Int NOT NULL AUTO_INCREMENT,
	`BIOBJ_ID` Int NOT NULL,
	`KPI_ID` Int NOT NULL,
 Primary Key (`ID_KPI_DOC`)) ENGINE = InnoDB;
 
Alter table `SBI_KPI_DOCUMENTS` add Foreign Key (`BIOBJ_ID`) references `SBI_OBJECTS` (`BIOBJ_ID`) on delete  restrict on update  restrict;
Alter table `SBI_KPI_DOCUMENTS` add Foreign Key (`KPI_ID`) references `SBI_KPI` (`KPI_ID`) on delete  restrict on update  restrict;

INSERT INTO SBI_KPI_DOCUMENTS(KPI_ID,BIOBJ_ID)
SELECT k.KPI_ID, o.BIOBJ_ID
FROM SBI_KPI k,SBI_OBJECTS o
WHERE
k.DOCUMENT_LABEL = o.LABEL
and k.DOCUMENT_LABEL IS NOT NULL;

ALTER TABLE SBI_KPI DROP COLUMN document_label;

--Antonella 08/09/2010: generic user data properties management
CREATE TABLE SBI_UDP (
	UDP_ID	        INTEGER  NOT NULL AUTO_INCREMENT,
	TYPE_ID			INTEGER NOT NULL,
	FAMILY_ID		INTEGER NOT NULL,
	LABEL           VARCHAR(20) NOT NULL,
	NAME            VARCHAR(40) NOT NULL,
	DESCRIPTION     VARCHAR(1000) NULL,
	IS_MULTIVALUE   BOOLEAN DEFAULT FALSE,    
 PRIMARY KEY (UDP_ID));
 
 
CREATE UNIQUE INDEX XAK1SBI_UDP ON SBI_UDP(LABEL ASC);
CREATE INDEX XIF3_SBI_SBI_UDP ON SBI_UDP(TYPE_ID ASC);
CREATE INDEX XIF2SBI_SBI_UDP ON SBI_UDP(FAMILY_ID ASC);
 
ALTER TABLE SBI_UDP ADD CONSTRAINT FK_SBI_SBI_UDP_1 FOREIGN KEY FK_SBI_UDP_1 ( TYPE_ID ) REFERENCES SBI_DOMAINS ( VALUE_ID ) ON DELETE RESTRICT;
ALTER TABLE SBI_UDP ADD CONSTRAINT FK_SBI_SBI_UDP_2 FOREIGN KEY FK_SBI_UDP_2 ( FAMILY_ID ) REFERENCES SBI_DOMAINS ( VALUE_ID ) ON DELETE RESTRICT;


CREATE TABLE SBI_UDP_VALUE (
	UDP_VALUE_ID       INTEGER  NOT NULL AUTO_INCREMENT,
	UDP_ID			   INTEGER NOT NULL,
	VALUE              VARCHAR(1000) NOT NULL,
	PROG               INTEGER NULL,
	LABEL              VARCHAR(20) NOT NULL,
	NAME               VARCHAR(40) NULL,
	FAMILY			   VARCHAR(40) NULL,
    BEGIN_TS           TIMESTAMP NOT NULL,
    END_TS             TIMESTAMP NULL,
    REFERENCE_ID	   INTEGER NULL,	
 PRIMARY KEY (UDP_VALUE_ID));
 
 
CREATE INDEX XIF2SBI_SBI_UDP_VALUE ON SBI_UDP_VALUE(UDP_ID ASC);

ALTER TABLE SBI_UDP_VALUE ADD CONSTRAINT FK_SBI_UDP_VALUE_2 FOREIGN KEY FK_SBI_UDP_VALUE_2 ( UDP_ID ) REFERENCES SBI_UDP ( UDP_ID ) ON DELETE RESTRICT;

--adds new funcionality for udp management
INSERT INTO SBI_USER_FUNC (NAME, DESCRIPTION) VALUES ('UserDefinedPropertyManagement', 'UserDefinedPropertyManagement');
INSERT INTO  SBI_ROLE_TYPE_USER_FUNC values((SELECT VALUE_ID FROM SBI_DOMAINS WHERE DOMAIN_CD = 'ROLE_TYPE' AND VALUE_CD = 'ADMIN'), (SELECT USER_FUNCT_ID FROM SBI_USER_FUNC WHERE NAME='UserDefinedPropertyManagement'));
COMMIT;

--KPI RELATIONS
CREATE TABLE SBI_KPI_REL (
  KPI_REL_ID INT(11) NOT NULL AUTO_INCREMENT,
  KPI_FATHER_ID INT(11)  NOT NULL,
  KPI_CHILD_ID INT(11)  NOT NULL,
  PARAMETER VARCHAR(100),
  PRIMARY KEY (KPI_REL_ID)
);

ALTER TABLE SBI_KPI_REL ADD CONSTRAINT FK_SBI_KPI_REL_3 FOREIGN KEY FK_SBI_KPI_REL_3 ( KPI_FATHER_ID ) REFERENCES SBI_KPI ( KPI_ID ) ON DELETE RESTRICT;
ALTER TABLE SBI_KPI_REL ADD CONSTRAINT FK_SBI_KPI_REL_4 FOREIGN KEY FK_SBI_KPI_REL_4 ( KPI_CHILD_ID ) REFERENCES SBI_KPI ( KPI_ID ) ON DELETE RESTRICT;

-- Kpi ERROR 28/09/2010
 CREATE TABLE SBI_KPI_ERROR (
  KPI_ERROR_ID INTEGER NOT NULL AUTO_INCREMENT,
  KPI_MODEL_INST_ID INTEGER NOT NULL,
  USER_MSG VARCHAR(1000),
  FULL_MSG TEXT,
  TS_DATE TIMESTAMP ,
  LABEL_MOD_INST VARCHAR(100) ,
  PARAMETERS VARCHAR(1000),
  PRIMARY KEY (KPI_ERROR_ID)
);
ALTER TABLE SBI_KPI_ERROR ADD CONSTRAINT FK_SBI_KPI_ERROR_MODEL_1 FOREIGN KEY FK_SBI_KPI_ERROR_MODEL_1 ( KPI_MODEL_INST_ID ) REFERENCES SBI_KPI_MODEL_INST ( KPI_MODEL_INST ) ON DELETE RESTRICT;
