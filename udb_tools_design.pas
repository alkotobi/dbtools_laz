unit udb_tools_design;

{$mode delphi}{$H+}
     interface
     uses
        classes,
        ujson,
        SysUtils,
        udb_types,
        SynCommons;

     const
      db_version =0.2;
   db_tools_db_json='{'+
'	"database_name": "db_tools_db",'+
'	"tables": ['+
'		{'+
'			"table_name": "databases",'+
'			"fields": ['+
'				{'+
'					"field_name": "database_name",'+
'					"field_type": "VARCHAR",'+
'					"field_length": 255,'+
'					"is_unique": false,'+
'					"is_not_null": false,'+
'					"is_indexed": false,'+
'					"default_value": "",'+
'					"description": "",'+
'					"is_required": false,'+
'					"is_visible": true,'+
'					"is_read_only": false,'+
'					"display_width": 30,'+
'					"display_label": "",'+
'					"is_calculated": false,'+
'					"ind": 1'+
'				},'+
'				{'+
'					"field_name": "version",'+
'					"field_type": "REAL",'+
'					"field_length": 0,'+
'					"is_unique": false,'+
'					"is_not_null": false,'+
'					"is_indexed": false,'+
'					"default_value": "",'+
'					"description": "",'+
'					"is_required": false,'+
'					"is_visible": true,'+
'					"is_read_only": false,'+
'					"display_width": 0,'+
'					"display_label": "",'+
'					"is_calculated": false,'+
'					"ind": 2'+
'				},'+
'				{'+
'					"field_name": "dot_pas_file_path",'+
'					"field_type": "VARCHAR",'+
'					"field_length": 255,'+
'					"is_unique": false,'+
'					"is_not_null": false,'+
'					"is_indexed": false,'+
'					"default_value": "",'+
'					"description": "",'+
'					"is_required": false,'+
'					"is_visible": true,'+
'					"is_read_only": false,'+
'					"display_width": 30,'+
'					"display_label": "",'+
'					"is_calculated": false,'+
'					"ind": 3'+
'				},'+
'				{'+
'					"field_name": "db_path",'+
'					"field_type": "VARCHAR",'+
'					"field_length": 255,'+
'					"is_unique": false,'+
'					"is_not_null": false,'+
'					"is_indexed": false,'+
'					"default_value": "",'+
'					"description": "",'+
'					"is_required": false,'+
'					"is_visible": true,'+
'					"is_read_only": false,'+
'					"display_width": 30,'+
'					"display_label": "",'+
'					"is_calculated": false,'+
'					"ind": 4'+
'				},'+
'				{'+
'					"field_name": "description",'+
'					"field_type": "TEXT",'+
'					"field_length": 0,'+
'					"is_unique": false,'+
'					"is_not_null": false,'+
'					"is_indexed": false,'+
'					"default_value": "",'+
'					"description": "",'+
'					"is_required": false,'+
'					"is_visible": true,'+
'					"is_read_only": false,'+
'					"display_width": 0,'+
'					"display_label": "",'+
'					"is_calculated": false,'+
'					"ind": 5'+
'				}],'+
'			"default_data": "",'+
'			"description": "",'+
'			"insert_sql": "    INSERT INTO \"databases\"(\"database_name\",\"version\",\"dot_pas_file_path\",\"db_path\",\"description\")\n    VALUES(:database_name,:version,:dot_pas_file_path,:db_path,:description);",'+
'			"insert_params_count": 5,'+
'			"is_view": false,'+
'			"create_sql": ""'+
'		},'+
'		{'+
'			"table_name": "field_types",'+
'			"fields": ['+
'				{'+
'					"field_name": "field_type",'+
'					"field_type": "VARCHAR",'+
'					"field_length": 20,'+
'					"is_unique": false,'+
'					"is_not_null": false,'+
'					"is_indexed": false,'+
'					"default_value": "",'+
'					"description": "",'+
'					"is_required": false,'+
'					"is_visible": true,'+
'					"is_read_only": false,'+
'					"display_width": 0,'+
'					"display_label": "",'+
'					"is_calculated": false,'+
'					"ind": 13'+
'				}],'+
'			"default_data": " †笠 †††∠摩㨢ㄠਬ††††昢敩摬祔数㨢∠义䕔䕇≒ †素ਬ††੻††††椢≤›ⰲ †††∠楦汥呤灹≥›嘢剁䡃剁ਢ††ⱽ †笠 †††∠摩㨢㌠ਬ††††昢敩摬祔数㨢∠䕒䱁ਢ††ⱽ †笠 †††∠摩㨢㐠ਬ††††昢敩摬祔数㨢∠䕔员ਢ††ⱽ †笠 †††∠摩㨢㔠ਬ††††昢敩摬祔数㨢∠䱂䉏ਢ††ⱽ †笠 †††∠摩㨢㘠ਬ††††昢敩摬祔数㨢∠佂䱏ਢ††ⱽ †笠 †††∠摩㨢㜠ਬ††††昢敩摬祔数㨢∠䅄䕔䥔䕍ਢ††੽?",'+
'			"description": "",'+
'			"insert_sql": "    INSERT INTO \"field_types\"(\"field_type\")\n    VALUES(:field_type);",'+
'			"insert_params_count": 1,'+
'			"is_view": false,'+
'			"create_sql": ""'+
'		},'+
'		{'+
'			"table_name": "fields",'+
'			"fields": ['+
'				{'+
'					"field_name": "field_name",'+
'					"field_type": "VARCHAR",'+
'					"field_length": 50,'+
'					"is_unique": false,'+
'					"is_not_null": false,'+
'					"is_indexed": false,'+
'					"default_value": "",'+
'					"description": "",'+
'					"is_required": false,'+
'					"is_visible": true,'+
'					"is_read_only": false,'+
'					"display_width": 10,'+
'					"display_label": "",'+
'					"is_calculated": false,'+
'					"ind": 1'+
'				},'+
'				{'+
'					"field_name": "field_type",'+
'					"field_type": "VARCHAR",'+
'					"field_length": 30,'+
'					"is_unique": false,'+
'					"is_not_null": false,'+
'					"is_indexed": false,'+
'					"default_value": "",'+
'					"description": "",'+
'					"is_required": false,'+
'					"is_visible": true,'+
'					"is_read_only": false,'+
'					"display_width": 10,'+
'					"display_label": "",'+
'					"is_calculated": false,'+
'					"ind": 2'+
'				},'+
'				{'+
'					"field_name": "field_length",'+
'					"field_type": "INTEGER",'+
'					"field_length": 0,'+
'					"is_unique": false,'+
'					"is_not_null": false,'+
'					"is_indexed": false,'+
'					"default_value": "",'+
'					"description": "",'+
'					"is_required": false,'+
'					"is_visible": true,'+
'					"is_read_only": false,'+
'					"display_width": 10,'+
'					"display_label": "",'+
'					"is_calculated": false,'+
'					"ind": 3'+
'				},'+
'				{'+
'					"field_name": "display_width",'+
'					"field_type": "INTEGER",'+
'					"field_length": 0,'+
'					"is_unique": false,'+
'					"is_not_null": false,'+
'					"is_indexed": false,'+
'					"default_value": "",'+
'					"description": "",'+
'					"is_required": false,'+
'					"is_visible": true,'+
'					"is_read_only": false,'+
'					"display_width": 10,'+
'					"display_label": "",'+
'					"is_calculated": false,'+
'					"ind": 5'+
'				},'+
'				{'+
'					"field_name": "display_label",'+
'					"field_type": "VARCHAR",'+
'					"field_length": 30,'+
'					"is_unique": false,'+
'					"is_not_null": false,'+
'					"is_indexed": false,'+
'					"default_value": "",'+
'					"description": "",'+
'					"is_required": false,'+
'					"is_visible": true,'+
'					"is_read_only": false,'+
'					"display_width": 10,'+
'					"display_label": "",'+
'					"is_calculated": false,'+
'					"ind": 6'+
'				},'+
'				{'+
'					"field_name": "is_visible",'+
'					"field_type": "BOOL",'+
'					"field_length": 0,'+
'					"is_unique": false,'+
'					"is_not_null": false,'+
'					"is_indexed": false,'+
'					"default_value": "1",'+
'					"description": "",'+
'					"is_required": false,'+
'					"is_visible": true,'+
'					"is_read_only": false,'+
'					"display_width": 0,'+
'					"display_label": "",'+
'					"is_calculated": false,'+
'					"ind": 7'+
'				},'+
'				{'+
'					"field_name": "ind",'+
'					"field_type": "INTEGER",'+
'					"field_length": 0,'+
'					"is_unique": false,'+
'					"is_not_null": false,'+
'					"is_indexed": false,'+
'					"default_value": "",'+
'					"description": "",'+
'					"is_required": false,'+
'					"is_visible": true,'+
'					"is_read_only": false,'+
'					"display_width": 0,'+
'					"display_label": "",'+
'					"is_calculated": false,'+
'					"ind": 7'+
'				},'+
'				{'+
'					"field_name": "default_value",'+
'					"field_type": "VARCHAR",'+
'					"field_length": 255,'+
'					"is_unique": false,'+
'					"is_not_null": false,'+
'					"is_indexed": false,'+
'					"default_value": "",'+
'					"description": "",'+
'					"is_required": false,'+
'					"is_visible": true,'+
'					"is_read_only": false,'+
'					"display_width": 10,'+
'					"display_label": "",'+
'					"is_calculated": false,'+
'					"ind": 8'+
'				},'+
'				{'+
'					"field_name": "is_calculated",'+
'					"field_type": "BOOL",'+
'					"field_length": 0,'+
'					"is_unique": false,'+
'					"is_not_null": false,'+
'					"is_indexed": false,'+
'					"default_value": "0",'+
'					"description": "",'+
'					"is_required": false,'+
'					"is_visible": true,'+
'					"is_read_only": false,'+
'					"display_width": 0,'+
'					"display_label": "",'+
'					"is_calculated": false,'+
'					"ind": 9'+
'				},'+
'				{'+
'					"field_name": "is_not_null",'+
'					"field_type": "BOOL",'+
'					"field_length": 0,'+
'					"is_unique": false,'+
'					"is_not_null": false,'+
'					"is_indexed": false,'+
'					"default_value": "0",'+
'					"description": "",'+
'					"is_required": false,'+
'					"is_visible": true,'+
'					"is_read_only": false,'+
'					"display_width": 0,'+
'					"display_label": "",'+
'					"is_calculated": false,'+
'					"ind": 10'+
'				},'+
'				{'+
'					"field_name": "is_unique",'+
'					"field_type": "BOOL",'+
'					"field_length": 0,'+
'					"is_unique": false,'+
'					"is_not_null": false,'+
'					"is_indexed": false,'+
'					"default_value": "0",'+
'					"description": "",'+
'					"is_required": false,'+
'					"is_visible": true,'+
'					"is_read_only": false,'+
'					"display_width": 0,'+
'					"display_label": "",'+
'					"is_calculated": false,'+
'					"ind": 11'+
'				},'+
'				{'+
'					"field_name": "is_indexed",'+
'					"field_type": "BOOL",'+
'					"field_length": 0,'+
'					"is_unique": false,'+
'					"is_not_null": false,'+
'					"is_indexed": false,'+
'					"default_value": "0",'+
'					"description": "",'+
'					"is_required": false,'+
'					"is_visible": true,'+
'					"is_read_only": false,'+
'					"display_width": 0,'+
'					"display_label": "",'+
'					"is_calculated": false,'+
'					"ind": 12'+
'				},'+
'				{'+
'					"field_name": "is_read_only",'+
'					"field_type": "BOOL",'+
'					"field_length": 0,'+
'					"is_unique": false,'+
'					"is_not_null": false,'+
'					"is_indexed": false,'+
'					"default_value": "0",'+
'					"description": "",'+
'					"is_required": false,'+
'					"is_visible": true,'+
'					"is_read_only": false,'+
'					"display_width": 0,'+
'					"display_label": "",'+
'					"is_calculated": false,'+
'					"ind": 13'+
'				},'+
'				{'+
'					"field_name": "is_required",'+
'					"field_type": "BOOL",'+
'					"field_length": 0,'+
'					"is_unique": false,'+
'					"is_not_null": false,'+
'					"is_indexed": false,'+
'					"default_value": "0",'+
'					"description": "",'+
'					"is_required": false,'+
'					"is_visible": true,'+
'					"is_read_only": false,'+
'					"display_width": 0,'+
'					"display_label": "",'+
'					"is_calculated": false,'+
'					"ind": 14'+
'				},'+
'				{'+
'					"field_name": "id_table",'+
'					"field_type": "INTEGER",'+
'					"field_length": 0,'+
'					"is_unique": false,'+
'					"is_not_null": false,'+
'					"is_indexed": false,'+
'					"default_value": "",'+
'					"description": "",'+
'					"is_required": false,'+
'					"is_visible": false,'+
'					"is_read_only": false,'+
'					"display_width": 0,'+
'					"display_label": "",'+
'					"is_calculated": false,'+
'					"ind": 15'+
'				},'+
'				{'+
'					"field_name": "description",'+
'					"field_type": "TEXT",'+
'					"field_length": 0,'+
'					"is_unique": false,'+
'					"is_not_null": false,'+
'					"is_indexed": false,'+
'					"default_value": "",'+
'					"description": "",'+
'					"is_required": false,'+
'					"is_visible": true,'+
'					"is_read_only": false,'+
'					"display_width": 15,'+
'					"display_label": "",'+
'					"is_calculated": false,'+
'					"ind": 16'+
'				}],'+
'			"default_data": "",'+
'			"description": "",'+
'			"insert_sql": "    INSERT INTO \"fields\"(\"field_name\",\"field_type\",\"field_length\",\"display_width\",\"display_label\",\"is_visible\",\"ind\",\"default_value\",\"is_calculated\",\"is_not_null\",\"is_unique\",\"is_indexed\",\"is_read_only\",\"is_required\",\"id_table\",\"description\")\n    VALUES(:field_name,:field_type,:field_length,:display_width,:display_label,:is_visible,:ind,:default_value,:is_calculated,:is_not_null,:is_unique,:is_indexed,:is_read_only,:is_required,:id_table,:description);",'+
'			"insert_params_count": 16,'+
'			"is_view": false,'+
'			"create_sql": ""'+
'		},'+
'		{'+
'			"table_name": "tables",'+
'			"fields": ['+
'				{'+
'					"field_name": "table_name",'+
'					"field_type": "VARCHAR",'+
'					"field_length": 50,'+
'					"is_unique": false,'+
'					"is_not_null": false,'+
'					"is_indexed": false,'+
'					"default_value": "",'+
'					"description": "",'+
'					"is_required": false,'+
'					"is_visible": true,'+
'					"is_read_only": false,'+
'					"display_width": 20,'+
'					"display_label": "",'+
'					"is_calculated": false,'+
'					"ind": 1'+
'				},'+
'				{'+
'					"field_name": "id_databse",'+
'					"field_type": "INTEGER",'+
'					"field_length": 0,'+
'					"is_unique": false,'+
'					"is_not_null": false,'+
'					"is_indexed": false,'+
'					"default_value": "",'+
'					"description": "",'+
'					"is_required": false,'+
'					"is_visible": false,'+
'					"is_read_only": false,'+
'					"display_width": 0,'+
'					"display_label": "",'+
'					"is_calculated": false,'+
'					"ind": 2'+
'				},'+
'				{'+
'					"field_name": "default_data",'+
'					"field_type": "TEXT",'+
'					"field_length": 0,'+
'					"is_unique": false,'+
'					"is_not_null": false,'+
'					"is_indexed": false,'+
'					"default_value": "",'+
'					"description": "",'+
'					"is_required": false,'+
'					"is_visible": false,'+
'					"is_read_only": false,'+
'					"display_width": 0,'+
'					"display_label": "",'+
'					"is_calculated": false,'+
'					"ind": 3'+
'				},'+
'				{'+
'					"field_name": "insert_sql",'+
'					"field_type": "TEXT",'+
'					"field_length": 0,'+
'					"is_unique": false,'+
'					"is_not_null": false,'+
'					"is_indexed": false,'+
'					"default_value": "",'+
'					"description": "",'+
'					"is_required": false,'+
'					"is_visible": false,'+
'					"is_read_only": false,'+
'					"display_width": 0,'+
'					"display_label": "",'+
'					"is_calculated": false,'+
'					"ind": 5'+
'				},'+
'				{'+
'					"field_name": "insert_params_count",'+
'					"field_type": "INTEGER",'+
'					"field_length": 0,'+
'					"is_unique": false,'+
'					"is_not_null": false,'+
'					"is_indexed": false,'+
'					"default_value": "",'+
'					"description": "",'+
'					"is_required": false,'+
'					"is_visible": false,'+
'					"is_read_only": false,'+
'					"display_width": 0,'+
'					"display_label": "",'+
'					"is_calculated": false,'+
'					"ind": 6'+
'				},'+
'				{'+
'					"field_name": "description",'+
'					"field_type": "TEXT",'+
'					"field_length": 0,'+
'					"is_unique": false,'+
'					"is_not_null": false,'+
'					"is_indexed": false,'+
'					"default_value": "",'+
'					"description": "",'+
'					"is_required": false,'+
'					"is_visible": true,'+
'					"is_read_only": false,'+
'					"display_width": 0,'+
'					"display_label": "",'+
'					"is_calculated": false,'+
'					"ind": 7'+
'				},'+
'				{'+
'					"field_name": "create_sql",'+
'					"field_type": "TEXT",'+
'					"field_length": 0,'+
'					"is_unique": false,'+
'					"is_not_null": false,'+
'					"is_indexed": false,'+
'					"default_value": "",'+
'					"description": "",'+
'					"is_required": false,'+
'					"is_visible": false,'+
'					"is_read_only": false,'+
'					"display_width": 50,'+
'					"display_label": "",'+
'					"is_calculated": false,'+
'					"ind": 8'+
'				},'+
'				{'+
'					"field_name": "is_view",'+
'					"field_type": "BOOL",'+
'					"field_length": 0,'+
'					"is_unique": false,'+
'					"is_not_null": false,'+
'					"is_indexed": false,'+
'					"default_value": "0",'+
'					"description": "",'+
'					"is_required": false,'+
'					"is_visible": true,'+
'					"is_read_only": false,'+
'					"display_width": 0,'+
'					"display_label": "",'+
'					"is_calculated": false,'+
'					"ind": 27'+
'				}],'+
'			"default_data": "",'+
'			"description": "",'+
'			"insert_sql": "    INSERT INTO \"tables\"(\"table_name\",\"id_databse\",\"default_data\",\"insert_sql\",\"insert_params_count\",\"description\",\"create_sql\",\"is_view\")\n    VALUES(:table_name,:id_databse,:default_data,:insert_sql,:insert_params_count,:description,:create_sql,:is_view);",'+
'			"insert_params_count": 8,'+
'			"is_view": false,'+
'			"create_sql": ""'+
'		},'+
'		{'+
'			"table_name": "version",'+
'			"fields": ['+
'				{'+
'					"field_name": "db_version",'+
'					"field_type": "REAL",'+
'					"field_length": 0,'+
'					"is_unique": false,'+
'					"is_not_null": false,'+
'					"is_indexed": false,'+
'					"default_value": "",'+
'					"description": "",'+
'					"is_required": false,'+
'					"is_visible": true,'+
'					"is_read_only": false,'+
'					"display_width": 0,'+
'					"display_label": "",'+
'					"is_calculated": false,'+
'					"ind": 235'+
'				}],'+
'			"default_data": "",'+
'			"description": "",'+
'			"insert_sql": "    INSERT INTO \"version\"(\"db_version\")\n    VALUES(:db_version);",'+
'			"insert_params_count": 1,'+
'			"is_view": false,'+
'			"create_sql": ""'+
'		}],'+
'	"version": 0.2,'+
'	"description": "",'+
'	"db_path": ""'+
'}';


    //----------------------------databases---------------------------------

   databases_table_name='databases';
   sql_databases_tbl_create= '  CREATE TABLE "databases" ('+
'     "id" INTEGER PRIMARY KEY {if Sqlite} AUTOINCREMENT {else} AUTO_INCREMENT {endif},'+
'     "database_name" VARCHAR(255) ,'+
'     "version" REAL,'+
'     "dot_pas_file_path" VARCHAR(255) ,'+
'     "db_path" VARCHAR(255) ,'+
'     "description" TEXT);' ;

     databases_database_name='database_name';
     databases_version='version';
     databases_dot_pas_file_path='dot_pas_file_path';
     databases_db_path='db_path';
     databases_description='description';
sql_databases_insert='    INSERT INTO "databases"("database_name","version","dot_pas_file_path","db_path","description")'+
'    VALUES(:database_name,:version,:dot_pas_file_path,:db_path,:description);';


    //----------------------------field_types---------------------------------

   field_types_table_name='field_types';
   sql_field_types_tbl_create= '  CREATE TABLE "field_types" ('+
'     "id" INTEGER PRIMARY KEY {if Sqlite} AUTOINCREMENT {else} AUTO_INCREMENT {endif},'+
'     "field_type" VARCHAR(20) );' ;

     field_types_field_type='field_type';
sql_field_types_insert='    INSERT INTO "field_types"("field_type")'+
'    VALUES(:field_type);';


    //----------------------------fields---------------------------------

   fields_table_name='fields';
   sql_fields_tbl_create= '  CREATE TABLE "fields" ('+
'     "id" INTEGER PRIMARY KEY {if Sqlite} AUTOINCREMENT {else} AUTO_INCREMENT {endif},'+
'     "field_name" VARCHAR(50) ,'+
'     "field_type" VARCHAR(30) ,'+
'     "field_length" INTEGER,'+
'     "display_width" INTEGER,'+
'     "display_label" VARCHAR(30) ,'+
'     "is_visible" BOOL DEFAULT 1,'+
'     "ind" INTEGER,'+
'     "default_value" VARCHAR(255) ,'+
'     "is_calculated" BOOL DEFAULT 0,'+
'     "is_not_null" BOOL DEFAULT 0,'+
'     "is_unique" BOOL DEFAULT 0,'+
'     "is_indexed" BOOL DEFAULT 0,'+
'     "is_read_only" BOOL DEFAULT 0,'+
'     "is_required" BOOL DEFAULT 0,'+
'     "id_table" INTEGER,'+
'     "description" TEXT);' ;

     fields_field_name='field_name';
     fields_field_type='field_type';
     fields_field_length='field_length';
     fields_display_width='display_width';
     fields_display_label='display_label';
     fields_is_visible='is_visible';
     fields_ind='ind';
     fields_default_value='default_value';
     fields_is_calculated='is_calculated';
     fields_is_not_null='is_not_null';
     fields_is_unique='is_unique';
     fields_is_indexed='is_indexed';
     fields_is_read_only='is_read_only';
     fields_is_required='is_required';
     fields_id_table='id_table';
     fields_description='description';
sql_fields_insert='    INSERT INTO "fields"("field_name","field_type","field_length","display_width","display_label","is_visible","ind","default_value","is_calculated","is_not_null","is_unique","is_indexed","is_read_only","is_required","id_table","description")'+
'    VALUES(:field_name,:field_type,:field_length,:display_width,:display_label,:is_visible,:ind,:default_value,:is_calculated,:is_not_null,:is_unique,:is_indexed,:is_read_only,:is_required,:id_table,:description);';


    //----------------------------tables---------------------------------

   tables_table_name='tables';
   sql_tables_tbl_create= '  CREATE TABLE "tables" ('+
'     "id" INTEGER PRIMARY KEY {if Sqlite} AUTOINCREMENT {else} AUTO_INCREMENT {endif},'+
'     "table_name" VARCHAR(50) ,'+
'     "id_databse" INTEGER,'+
'     "default_data" TEXT,'+
'     "insert_sql" TEXT,'+
'     "insert_params_count" INTEGER,'+
'     "description" TEXT,'+
'     "create_sql" TEXT,'+
'     "is_view" BOOL DEFAULT 0);' ;

     tables_table_name_fld='table_name';
     tables_id_databse='id_databse';
     tables_default_data='default_data';
     tables_insert_sql='insert_sql';
     tables_insert_params_count='insert_params_count';
     tables_description='description';
     tables_create_sql='create_sql';
     tables_is_view='is_view';
sql_tables_insert='    INSERT INTO "tables"("table_name","id_databse","default_data","insert_sql","insert_params_count","description","create_sql","is_view")'+
'    VALUES(:table_name,:id_databse,:default_data,:insert_sql,:insert_params_count,:description,:create_sql,:is_view);';


    //----------------------------version---------------------------------

   version_table_name='version';
   sql_version_tbl_create= '  CREATE TABLE "version" ('+
'     "id" INTEGER PRIMARY KEY {if Sqlite} AUTOINCREMENT {else} AUTO_INCREMENT {endif},'+
'     "db_version" REAL);' ;

     version_db_version='db_version';
sql_version_insert='    INSERT INTO "version"("db_version")'+
'    VALUES(:db_version);';

 var 
   db_tools_db_def:mndatabase;
implementation
initialization
    TTextWriter.RegisterCustomJSONSerializerFromText( TypeInfo(db_tools_db_def),__mndatabase_entry_value).Options := [soReadIgnoreUnknownFields,soWriteHumanReadable];
 db_tools_db_def := deserializer<mndatabase>(db_tools_db_json);
END.
