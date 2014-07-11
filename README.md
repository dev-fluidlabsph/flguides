## Starting with Spring ROO
==================

This is a sample code to start a project using Spring ROO.  Following are the requirements and step to setup your development environment.

## Requirements

    Spring STS [http://spring.io/tools/sts/all][] the latest version is 3.5.0
    Spring ROO - [http://projects.spring.io/spring-roo][] The current stable release is 1.2.5
    
## Steps to setup your IDE
    1. Unpack and install STS to your favorite location, just like installing a normal eclipse IDE.
    2. Again, unpack Spring Roo to your favorite location. e.g. 'C:\Windows\Users\<Your Account>\Documents', '/Users/<Your Account>/Document' for Mac OSX
    3. Add Roo to your classpath. On windows (booooo), 'Start->Control Panel->System->Advanced Tab->Environment Variables->System Variables->Path'. On MAC OSX, '/Users/<Your Account>/.profile or .bash_profile'
    4. Once done, open your terminal type roo then press enter.  You should see the Roo's welcome message and version like the one below.

           ____  ____  ____  
        
           / __ \/ __ \/ __ \ 
        
          / /_/ / / / / / / / 
        
         / _, _/ /_/ / /_/ /  
        
        /_/ |_|\____/\____/    1.2.5.RELEASE [rev 8341dc2]
        
        Welcome to Spring Roo. For assistance press TAB or type "hint" then hit ENTER.
        
        roo> 

    5. Open STS IDE, then go to 'HELP -> Eclipse Market' and look for the [Spring Roo plugin][] for STS, take note of the version of your STS.
    6. Create new Spring Roo Project. Right click on 'Project Explorer -> New -> Others -> Spring Roo Project'.  Usually, it will automatically open Roo Shell for you, in case not just right click on your project then click 'Spring Tools -> Roo Shell'.
    7. There are 3 ways to create Roo project, first is the one I've mentioned on step 6 and second is via Roo Shell.  Just click the Create New Roo Project button at the upper right corner of the shell. There, you can specify the installation path of your Roo instance.  The third way is using your terminal, that's the purpose of adding Roo to your classpath and this step doesn't use IDE.  Whichever way you choose, it's your personal taste.



##DB Reverse Engineering
==================

This a quick tutorial on how create your application using one of the very impressive feature of Spring ROO, the DBRE.  In fact, this feature is not new for most of the developers.  JPA offers this but only allows you to instrospect the db schema and produce Java application once while Roo's version gives you the advantage of repeatedly doing it (re-instrospect and update the application).  Here, we are gonna create a sample project to demonstrate how DBRE works.

Requirements:

1. PostgreSQL
2. Spring ROO, latest version is 1.2.5

Steps:

1.	If you haven't installed Spring ROO yet, then download it here http://projects.spring.io/spring-roo. 	
2.	Extract it to your favorite directory and add it to your PATH system variable.  In OSX you can add PATH in <b>.profile</b> at your home directory.
	
	```
	export ROO_HOME="/Users/<your-home-directory>/spring-roo-1.2.5.RELEASE"
	export PATH="$PATH:$ROO_HOME/bin"
	```
		
3.	Download and install PostgreSQL. http://www.postgresql.org/download
4.	Using PgAdmin or terminal create a database
5.	Use the sql below to create tables on your db.

	```
	DROP TABLE IF EXISTS account;
	DROP TABLE IF EXISTS salary;
	DROP TABLE IF EXISTS employee;
	DROP TABLE IF EXISTS user_role;
	DROP TABLE IF EXISTS account_roles;
	
	CREATE TABLE account
	(
	  id bigserial NOT NULL,
	  enabled boolean,
	  password character varying(255),
	  username character varying(255),
	  version integer,
	  CONSTRAINT account_pkey PRIMARY KEY (id )
	)
	WITH (
	  OIDS=FALSE
	);
	ALTER TABLE account OWNER TO postgres;
	
	CREATE TABLE salary
	(
	  id bigserial NOT NULL,
	  code character varying(255) NOT NULL,
	  description character varying(255),
	  version integer,
	  CONSTRAINT salary_pkey PRIMARY KEY (id )
	)
	WITH (
	  OIDS=FALSE
	);
	ALTER TABLE salary OWNER TO postgres;
	
	CREATE TABLE user_role
	(
	  id bigserial NOT NULL,
	  role_name character varying(255),
	  version integer,
	  CONSTRAINT user_role_pkey PRIMARY KEY (id )
	)
	WITH (
	  OIDS=FALSE
	);
	ALTER TABLE user_role OWNER TO postgres;
	
	CREATE TABLE employee
	(
	  id bigserial NOT NULL,
	  address character varying(255) NOT NULL,
	  first_name character varying(255) NOT NULL,
	  last_name character varying(255) NOT NULL,
	  middle_name character varying(255) NOT NULL,
	  version integer,
	  salary bigint,
	  CONSTRAINT employee_pkey PRIMARY KEY (id ),
	  CONSTRAINT fk_trifo3miwmqe2tl40vjxqx8u9 FOREIGN KEY (salary)
	      REFERENCES salary (id) MATCH SIMPLE
	      ON UPDATE NO ACTION ON DELETE NO ACTION
	)
	WITH (
	  OIDS=FALSE
	);
	ALTER TABLE employee OWNER TO postgres;
	
	CREATE TABLE account_roles
	(
	  account bigint NOT NULL,
	  roles bigint NOT NULL,
	  CONSTRAINT account_roles_pkey PRIMARY KEY (account , roles ),
	  CONSTRAINT fk_7dw3qmgby3x1lcjp7ijts8fa5 FOREIGN KEY (roles)
	      REFERENCES user_role (id) MATCH SIMPLE
	      ON UPDATE NO ACTION ON DELETE NO ACTION,
	  CONSTRAINT fk_avjbyhyjd6nnh52cr6ij2pujp FOREIGN KEY (account)
	      REFERENCES account (id) MATCH SIMPLE
	      ON UPDATE NO ACTION ON DELETE NO ACTION
	)
	WITH (
	  OIDS=FALSE
	);
	ALTER TABLE account_roles OWNER TO postgres;
	```

5.	On your machine create a new directory for your project e.g. <b>dbresample</b> then go to that newly created folder.
6.	Open your ROO shell by typing <b>roo</b> in your console.

	```
	dbresample $ roo
	```
7.	Type the following roo commands in your console.

	```
	roo> project --topLevelPackage com.sample
	roo> jpa setup --database POSTGRES --provider HIBERNATE 
		--databaseName <name-of-your-db> 
		--userName <your-db-username> 
		--password <your-db-password> 
	roo> database introspect --schema public 
	roo> database reverse engineer --schema public --package ~.domain --activeRecord
	```
	Succesful execution of the above commands will produce the following output in your shell.
	
	```
	roo> database reverse engineer --schema public --package ~.domain --activeRecord
	Created SRC_MAIN_RESOURCES/dbre.xml
	Created SRC_MAIN_JAVA/com/sample/domain/Account.java
	Created SRC_MAIN_JAVA/com/sample/domain/Employee.java
	Created SRC_MAIN_JAVA/com/sample/domain/Salary.java
	Created SRC_MAIN_JAVA/com/sample/domain/UserRole.java
	Created SRC_MAIN_JAVA/com/sample/domain/Account_Roo_ToString.aj
	Created SRC_MAIN_JAVA/com/sample/domain/Account_Roo_DbManaged.aj
	Created SRC_MAIN_JAVA/com/sample/domain/Account_Roo_Jpa_Entity.aj
	Created SRC_MAIN_JAVA/com/sample/domain/Employee_Roo_ToString.aj
	Created SRC_MAIN_JAVA/com/sample/domain/Employee_Roo_DbManaged.aj
	Created SRC_MAIN_JAVA/com/sample/domain/Employee_Roo_Jpa_Entity.aj
	Created SRC_MAIN_JAVA/com/sample/domain/Salary_Roo_ToString.aj
	Created SRC_MAIN_JAVA/com/sample/domain/Salary_Roo_DbManaged.aj
	Created SRC_MAIN_JAVA/com/sample/domain/Salary_Roo_Jpa_Entity.aj
	Created SRC_MAIN_JAVA/com/sample/domain/UserRole_Roo_ToString.aj
	Created SRC_MAIN_JAVA/com/sample/domain/UserRole_Roo_DbManaged.aj
	Created SRC_MAIN_JAVA/com/sample/domain/UserRole_Roo_Jpa_Entity.aj
	```
8.	In case that you encounter error about the missing <b>roo addon</b> use these commands to fix it. In this example it will look for <b>jdbc postgresql addon.</b>

	```
	roo> addon search jdbc
	roo> addon install id --searchResultId <ID of the addon>
	```
	Example:
	
	```
	roo> addon search jdbc
	8 found, sorted by rank; T = trusted developer; R = Roo 1.2 compatible
	ID T R DESCRIPTION
	01 Y Y 1.2.4.0010 #jdbcdriver driverclass:net.sourceforge.jtds.jdbc.Driver.
	       This bundle wraps the standard Maven artifact: jtds-1.2.4.
	02 Y Y 5.1.18.0001 #jdbcdriver driverclass:com.mysql.jdbc.Driver. This bundle
	       wraps the standard Maven artifact: mysql-connector-java-5.1.18.
	03 Y Y 10.8.2.2_0001 Derby Client #jdbcdriver
	       driverclass:org.apache.derby.jdbc.ClientDriver. This bundle wraps the...
	04 Y Y 6.7.0.0010 #jdbcdriver driverclass:com.ibm.as400.access.AS400JDBCDriver.
	       This bundle wraps the standard Maven artifact: jtopen-6.7.
	05 Y Y 10.8.2.2_0001 Derby #jdbcdriver
	       driverclass:org.apache.derby.jdbc.EmbeddedDriver. This bundle wraps...
	06 Y Y 9.1.0.901_0001 Postgres #jdbcdriver driverclass:org.postgresql.Driver.
	       This bundle wraps the standard Maven artifact:...
	07 Y Y 1.3.170.0001 H2 #jdbcdriver driverclass:org.h2.Driver. This bundle wraps
	       the standard Maven artifact: h2-1.3.170.
	08 Y Y 2.1.6.0020 #jdbcdriver driverclass:org.firebirdsql.jdbc.FBDriver. This
	       bundle wraps the standard Maven artifact: firebird-2.1.6.
	roo> addon install id --searchResultId 06
	```
	
	Run the commands again on step 7.
10.	Download or clone the project "dbresample" if you want to see the working sample.


<b>Related document(s):</b>

http://docs.spring.io/spring-roo/reference/html