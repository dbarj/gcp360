-----------------------------------------
-- Tables Used in this Section
-----------------------------------------
@@&&fc_json_loader. 'GCP_FIREBASE_TEST_ANDROID_LOCALES'
@@&&fc_json_loader. 'GCP_FIREBASE_TEST_ANDROID_MODELS'
@@&&fc_json_loader. 'GCP_FIREBASE_TEST_ANDROID_VERSIONS'
@@&&fc_json_loader. 'GCP_FIREBASE_TEST_IOS_LOCALES'
@@&&fc_json_loader. 'GCP_FIREBASE_TEST_IOS_MODELS'
@@&&fc_json_loader. 'GCP_FIREBASE_TEST_IOS_VERSIONS'
@@&&fc_json_loader. 'GCP_FIREBASE_TEST_NETWORK_PROFILES'
-----------------------------------------

DEF title = 'Firebase Test Android Locales'
DEF main_table = 'GCP_FIREBASE_TEST_ANDROID_LOCALES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_FIREBASE_TEST_ANDROID_LOCALES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Firebase Test Android Models'
DEF main_table = 'GCP_FIREBASE_TEST_ANDROID_MODELS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_FIREBASE_TEST_ANDROID_MODELS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Firebase Test Android Versions'
DEF main_table = 'GCP_FIREBASE_TEST_ANDROID_VERSIONS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_FIREBASE_TEST_ANDROID_VERSIONS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Firebase Test Ios Locales'
DEF main_table = 'GCP_FIREBASE_TEST_IOS_LOCALES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_FIREBASE_TEST_IOS_LOCALES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Firebase Test Ios Models'
DEF main_table = 'GCP_FIREBASE_TEST_IOS_MODELS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_FIREBASE_TEST_IOS_MODELS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Firebase Test Ios Versions'
DEF main_table = 'GCP_FIREBASE_TEST_IOS_VERSIONS'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_FIREBASE_TEST_IOS_VERSIONS t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------

DEF title = 'Firebase Test Network Profiles'
DEF main_table = 'GCP_FIREBASE_TEST_NETWORK_PROFILES'

BEGIN
  :sql_text := q'{
SELECT t1.*
FROM   GCP_FIREBASE_TEST_NETWORK_PROFILES t1
}';
END;
/
@@&&9a_pre_one.

-----------------------------------------