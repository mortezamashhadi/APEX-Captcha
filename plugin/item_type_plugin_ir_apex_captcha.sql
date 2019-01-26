prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_180100 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2016.08.24'
,p_release=>'5.1.4.00.08'
,p_default_workspace_id=>1959532611173926
,p_default_application_id=>100
,p_default_owner=>''
);
end;
/
prompt --application/shared_components/plugins/item_type/ir_apex_captcha
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(42810672341395865)
,p_plugin_type=>'ITEM TYPE'
,p_name=>'IR_APEX_CAPTCHA'
,p_display_name=>'APEX Captcha'
,p_supported_ui_types=>'DESKTOP:JQM_SMARTPHONE'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS'
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'FUNCTION render_captcha (',
'    p_item                in apex_plugin.t_page_item, -- Holds item name, label and custom attributes',
'    p_plugin              in apex_plugin.t_plugin,    -- The plugin name',
'    p_value               in varchar2,                -- Is the field value of the item',
'	p_is_readonly         in boolean,                 -- Should the item be readonly',
'    p_is_printer_friendly in boolean',
'	)',
'    return apex_plugin.t_page_item_render_result',
'IS',
'',
'	num01		  number;',
'	num02		  number;',
'	tmpNum		  number;',
'	opCode		  number;',
'    opName    	  VARCHAR2(30);',
'	opName_img	  clob;',
'	op			  VARCHAR2(30);',
'    -- Apex mandates that the PLSQL render function for a plugin returns apex_plugin.t_page_item_render_result.',
'    l_result      apex_plugin.t_page_item_render_result;',
'    v_width number:=p_item.element_width;',
'    v_type number := p_item.attribute_01;',
'    v_SUBMIT VARCHAR2(200) := p_item.attribute_02;',
'    lv_string varchar2(32676);',
'    v_captchaValue varchar2(100);',
'BEGIN',
'    ',
'    if not apex_collection.collection_exists(''APEXCAPTCHA_RESAULT'') then ',
'       apex_collection.create_collection(''APEXCAPTCHA_RESAULT'');',
'    end if;',
'    ',
'    ',
'    IF v_SUBMIT=''Y'' THEN',
'        v_SUBMIT:=''onkeypress="return apex.submit({request:''''''||p_item.name||'''''',submitIfEnter:event})"'';',
'    ELSE',
'        v_SUBMIT:='''';',
'    END IF;',
'',
'',
'    num01:=round(dbms_random.value(0,10));',
'    num02:=round(dbms_random.value(0,10));',
'    opCode:=round(dbms_random.value(1,3));',
'',
'    if opCode=1 then',
'        opName:=''plus'';',
'        op:=''+'';',
'    elsif opCode=2 then',
'        opName:=''multiplied by'';',
'        op:=''*'';',
'    else',
'        if num01<num02 then',
'            tmpNum:=num01;',
'            num01:=num02;',
'            num02:=tmpNum;',
'        end if;',
'        opName:=''minus'';',
'        op:=''-'';',
'    end if;',
'',
'',
'',
'    htp.p(''<input type="text" ''||v_SUBMIT||'' autocomplete="off"  style="direction:ltr; order:1; text-align:center" name="''||p_item.name||',
'    ''" id="''||p_item.name||''" required=""''||',
'    ''size="''||v_width||''" ''||',
'    ''maxlength="2" ''||',
'    ''class="text_field apex-item-text apex-item-has-icon ''||p_item.element_css_classes||''" ''||',
'    p_item.element_attributes||',
'    ''/>'');',
'    ',
'    ',
'     if v_type=1 then',
'        opName_img:=FN_GETBASE64(num01||'' ''||op||'' ''||num02);',
'    htp.p(''<img src="''||opName_img||''" style="order:2;width:80px;height:30px">'');',
'    else',
'        htp.p(num01 ||'' ''||opName||'' ''|| num02);',
'    end if;',
'    ',
'    ',
'    if p_item.icon_css_classes is not null then',
'        htp.p(''<span class="apex-item-icon fa ''||p_item.icon_css_classes||''" aria-hidden="true"></span>'');',
'    end if;',
'',
'    execute immediate ''select ''||num01||op||num02||'' from dual'' INTO v_captchaValue ;',
'    APEX_COLLECTION.TRUNCATE_COLLECTION ( ''APEXCAPTCHA_RESAULT'');',
'    apex_collection.add_member(',
'        p_collection_name => ''APEXCAPTCHA_RESAULT'',',
'        p_c001 =>            v_captchaValue',
'    );',
'    ',
'    RETURN l_result;',
'',
'END render_captcha ;',
'',
'FUNCTION validate_captcha (',
'    p_item   IN     APEX_PLUGIN.t_page_item, ',
'    p_plugin IN     APEX_PLUGIN.t_plugin,    ',
'    p_value  IN     VARCHAR2)                ',
'    RETURN APEX_PLUGIN.t_page_item_validation_result',
'IS',
'	l_result       	apex_plugin.t_page_item_validation_result;',
'    v_captchaValue  varchar2(200);',
'BEGIN	',
'    BEGIN',
'    ',
'    select nvl(C001,1) into v_captchaValue',
'        from apex_collections',
'    where collection_name = ''APEXCAPTCHA_RESAULT'';',
'		IF upper(v_captchaValue) = upper(p_value) THEN',
'			return l_result;',
'        ELSE',
'			l_result.message := ''wrong captcha!'';',
'			return l_result;',
'		END IF;       ',
'    EXCEPTION WHEN OTHERS THEN',
'        l_result.message := ''captcha exception Error!''; ',
'        return l_result;     ',
'	END;	',
'	RETURN l_result;',
'END validate_captcha;',
'',
''))
,p_api_version=>1
,p_render_function=>'render_captcha'
,p_validation_function=>'validate_captcha'
,p_standard_attributes=>'VISIBLE:SESSION_STATE:ELEMENT:WIDTH:ELEMENT_OPTION:PLACEHOLDER:ICON'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>',
'	Version 1.0<br />',
'	Date 19/01/2019<br />',
'	Author: Morteza Mashhadi<br />',
'	captcha Item plugin<br />',
'	&nbsp;</p>',
'<p>',
'	This plugin prevent robots to submit forms.</p>'))
,p_version_identifier=>'1.0'
,p_about_url=>'http://mortezamashhadi.blogspot.com'
,p_files_version=>9
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(42810836679395867)
,p_plugin_id=>wwv_flow_api.id(42810672341395865)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Type'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'1'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(42811718131395868)
,p_plugin_attribute_id=>wwv_flow_api.id(42810836679395867)
,p_display_sequence=>10
,p_display_value=>'Image'
,p_return_value=>'1'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(42811204281395867)
,p_plugin_attribute_id=>wwv_flow_api.id(42810836679395867)
,p_display_sequence=>20
,p_display_value=>'Text'
,p_return_value=>'2'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(42812209346395868)
,p_plugin_id=>wwv_flow_api.id(42810672341395865)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Submit when Enter pressed'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'Y'
,p_supported_ui_types=>'DESKTOP:JQM_SMARTPHONE'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS'
,p_is_translatable=>false
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
