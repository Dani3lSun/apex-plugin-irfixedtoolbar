set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_050000 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2013.01.01'
,p_release=>'5.0.2.00.07'
,p_default_workspace_id=>96713923238010156
,p_default_application_id=>57743
,p_default_owner=>'DHTEST'
);
end;
/
prompt --application/ui_types
begin
null;
end;
/
prompt --application/shared_components/plugins/dynamic_action/de_danielh_irfixedtoolbar
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(21083664404181965818)
,p_plugin_type=>'DYNAMIC ACTION'
,p_name=>'DE.DANIELH.IRFIXEDTOOLBAR'
,p_display_name=>'IR Fixed Toolbar'
,p_category=>'INIT'
,p_supported_ui_types=>'DESKTOP'
,p_plsql_code=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'/*-------------------------------------',
' * IR Fixed Toolbar JS Functions',
' * Version: 1.0 (14.12.2015)',
' * Author:  Daniel Hochleitner',
' *-------------------------------------',
'*/',
'FUNCTION render_fixedtoolbar(p_dynamic_action IN apex_plugin.t_dynamic_action,',
'                             p_plugin         IN apex_plugin.t_plugin)',
'  RETURN apex_plugin.t_dynamic_action_render_result IS',
'  --',
'  -- plugin attributes',
'  l_result apex_plugin.t_dynamic_action_render_result;',
'  -- other vars',
'  l_js_string        VARCHAR2(4000);',
'  l_region_static_id VARCHAR2(100);',
'  l_ir_toolbar_id    VARCHAR2(150);',
'  l_ir_datapanel_id  VARCHAR2(150);',
'  -- Cursor for IR Region ID ',
'  CURSOR l_cur_affected_region IS',
'    SELECT nvl(apex_application_page_regions.static_id,',
'               ''R'' || apex_application_page_regions.region_id) AS static_id',
'      FROM apex_application_page_regions',
'     WHERE apex_application_page_regions.application_id = v(''APP_ID'')',
'       AND apex_application_page_regions.region_id IN',
'           (SELECT apex_application_page_da_acts.affected_region_id',
'              FROM apex_application_page_da_acts',
'             WHERE apex_application_page_da_acts.application_id =',
'                   v(''APP_ID'')',
'               AND apex_application_page_da_acts.affected_elements_type_code =',
'                   ''REGION''',
'               AND apex_application_page_da_acts.action_id =',
'                   p_dynamic_action.id);',
'  --',
'BEGIN',
'  -- Debug',
'  IF apex_application.g_debug THEN',
'    apex_plugin_util.debug_dynamic_action(p_plugin         => p_plugin,',
'                                          p_dynamic_action => p_dynamic_action);',
'  END IF;',
'  --',
'  -- Open Cursor and fetch into region ID',
'  OPEN l_cur_affected_region;',
'  FETCH l_cur_affected_region',
'    INTO l_region_static_id;',
'  CLOSE l_cur_affected_region;',
'  --',
'  l_ir_toolbar_id   := l_region_static_id || ''_toolbar'';',
'  l_ir_datapanel_id := l_region_static_id || ''_data_panel'';',
'  --',
'  -- build js string (Set dynamic style (top px) of IR column headers)',
'  l_js_string := ''var ifSelector;'' || chr(10) ||',
'                 ''function changeIRHeaderHeight_'' || l_region_static_id ||',
'                 ''() {'' || chr(10) || ''    if ($("#'' || l_ir_datapanel_id ||',
'                 '' .t-fht-thead").css("top") !== "auto") {'' || chr(10) ||',
'                 ''      if (Number($("#'' || l_ir_datapanel_id ||',
'                 '' .t-fht-thead").css("top").replace(/[^-\d\.]/g, "")) !== ifSelector) {'' ||',
'                 chr(10) || ''        var topPixel = $("#'' ||',
'                 l_ir_datapanel_id ||',
'                 '' .t-fht-thead").css("top").replace(/[^-\d\.]/g, "");'' ||',
'                 chr(10) || ''        var toolbarHeight = $("#'' ||',
'                 l_ir_toolbar_id ||',
'                 ''").next("div").css("height").replace(/[^-\d\.]/g, "");'' ||',
'                 chr(10) ||',
'                 ''        var newPixel = Number(topPixel) + Number(toolbarHeight);'' ||',
'                 chr(10) ||',
'                 ''        ifSelector = Number(topPixel) + Number(toolbarHeight);'' ||',
'                 chr(10) || ''        $("#'' || l_ir_datapanel_id ||',
'                 '' .t-fht-thead").css("top",newPixel + "px");'' || chr(10) ||',
'                 ''          }'' || chr(10) || ''    } else {'' || chr(10) ||',
'                 ''         $("#'' || l_ir_datapanel_id ||',
'                 '' .t-fht-thead").css("top","auto");'' || chr(10) ||',
'                 ''         ifSelector = "auto";'' || chr(10) || ''    }'' ||',
'                 chr(10) || ''    setTimeout(changeIRHeaderHeight_'' ||',
'                 l_region_static_id || '', 50);'' || chr(10) || ''}'';',
'  --',
'  -- write inline JS code',
'  apex_javascript.add_inline_code(p_code => l_js_string);',
'  --',
'  -- execute changeIRHeaderHeight and stickyWidget of IR toolbar',
'  l_result.javascript_function := ''function(){changeIRHeaderHeight_'' ||',
'                                  l_region_static_id || ''();$("#'' ||',
'                                  l_ir_toolbar_id ||',
'                                  ''").stickyWidget({toggleWidth:true});}'';',
'  --',
'  RETURN l_result;',
'  --',
'END render_fixedtoolbar;'))
,p_render_function=>'render_fixedtoolbar'
,p_standard_attributes=>'REGION:REQUIRED:ONLOAD'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_help_text=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'This Dynamic Action Plugin is useful for setting an IR toolbar including the column header of all columns fixed to page when scrolling through the report.',
'The toolbar including search field and action menu or IR toolbar buttons stays on top while a user scrolls through the IR results.',
'Only use this plugin in combination with APEX 5 Universal Theme!'))
,p_version_identifier=>'1.0'
,p_about_url=>'https://github.com/Dani3lSun/apex-plugin-irfixedtoolbar'
);
end;
/
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false), p_is_component_import => true);
commit;
end;
/
set verify on feedback on define on
prompt  ...done
