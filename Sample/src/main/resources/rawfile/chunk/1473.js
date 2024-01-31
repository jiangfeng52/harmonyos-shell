/*! For license information please see 1473.js.LICENSE.txt */
"use strict";(self.webpackJsonp=self.webpackJsonp||[]).push([[1473],{"63682":function(e,n,t){t.d(n,{"Z":function(){return h}});var a=t(82163),c=t(6676),o=t(65599),i=t(97150),s=t(77483),l=t(26380),r=t(21065),u=t(35859),d=t(38036),f=t(91753),p=t(66658),m=function(e){(0,i.Z)(Index,e);var n=(0,s.Z)(Index);function Index(){var e;(0,a.Z)(this,Index);for(var t=arguments.length,c=new Array(t),i=0;i<t;i++)c[i]=arguments[i];return e=n.call.apply(n,[this].concat(c)),(0,l.Z)((0,o.Z)(e),"state",{}),(0,l.Z)((0,o.Z)(e),"stringify",(function(e){var n=new Map,t=JSON.stringify(e,(function(e,t){if(void 0===t)return"undefined";if("function"==typeof t)return"function";if("object"===(0,f.Z)(t)&&null!==t){if(n.has(t))return;n.set(t,t)}return t}));return n.clear(),t})),e}return(0,c.Z)(Index,[{"key":"render","value":function render(){var e=this.props,n=e.testApi,t=e.callbackRes;return(0,p.jsx)(d.View,{"className":"callback-content","children":(0,p.jsx)(d.View,{"className":"callback-res","id":"".concat(n,"-callback"),"children":this.stringify(t)})})}}]),Index}(r.Component),h=function(e){(0,i.Z)(Index,e);var n=(0,s.Z)(Index);function Index(){var e;(0,a.Z)(this,Index);for(var t=arguments.length,c=new Array(t),i=0;i<t;i++)c[i]=arguments[i];return e=n.call.apply(n,[this].concat(c)),(0,l.Z)((0,o.Z)(e),"state",{"inputData":[],"textareaControl":[],"hiddenNum":0}),(0,l.Z)((0,o.Z)(e),"changeData",(function(n,t){var a=e.state.inputData;try{a[t]=JSON.parse(n.detail.value)}catch(e){a[t]=n.detail.value}e.setState({"inputData":a})})),(0,l.Z)((0,o.Z)(e),"submitData",(function(e,n,t){null!=n.func&&("string"==typeof e?(0,u.CF)({"icon":"error","title":"请检查参数格式"}):null==e?n.func(t):n.func(t,e))})),(0,l.Z)((0,o.Z)(e),"minusHidden",(function(){var n=e.state.hiddenNum;n>0?e.setState({"hiddenNum":n-1}):(0,u.CF)({"title":"已全部显示"})})),(0,l.Z)((0,o.Z)(e),"addHidden",(function(){var n=e.state.hiddenNum;n<e.props.buttonList.length?e.setState({"hiddenNum":n+1}):(0,u.CF)({"title":"已全部隐藏"})})),(0,l.Z)((0,o.Z)(e),"hideTextarea",(function(n){var t=e.state.textareaControl;t[n]=!t[n],e.setState({"textareaControl":t})})),(0,l.Z)((0,o.Z)(e),"isAdvancedAPI",(function(e){try{return asAPIMap.get(e)}catch(e){return!1}})),e}return(0,c.Z)(Index,[{"key":"componentDidMount","value":function componentDidMount(){var e=this.props.buttonList,n=[],t=[];e.forEach((function(e){e.inputData?n.push(e.inputData):n.push(void 0),t.push(!0)})),this.setState({"inputData":n})}},{"key":"render","value":function render(){var e=this,n=this.props.buttonList,t=this.state,a=t.inputData,c=t.textareaControl,o=t.hiddenNum;return(0,p.jsxs)(d.View,{"className":"button-list","children":[(0,p.jsxs)(d.View,{"className":"hidden-control","children":[(0,p.jsx)(d.Text,{"children":"隐藏按钮"}),(0,p.jsxs)(d.View,{"className":"stepper","children":[(0,p.jsx)(d.View,{"className":"normal","onClick":this.minusHidden,"children":"-"}),(0,p.jsx)(d.View,{"className":"stepper-num","children":o}),(0,p.jsx)(d.View,{"className":"normal","onClick":this.addHidden,"children":"+"})]})]}),n.map((function(n,t){return(0,p.jsxs)(d.View,{"className":"api-page-btn-area ".concat(t<o?"api-page-btn-area-hidden":""),"children":[null!=a[t]?(0,p.jsxs)(d.View,{"className":"api-textarea-area","children":[(0,p.jsx)(d.Textarea,{"className":"api-input-area ".concat(c[t]?"api-input-area-hidden":""),"maxlength":-1,"id":"".concat(n.id,"-input"),"value":"string"==typeof a[t]?a[t]:JSON.stringify(a[t],null,2),"onInput":function onInput(n){e.changeData(n,t)}}),(0,p.jsx)(d.View,{"className":"textarea-control","onClick":function onClick(){e.hideTextarea(t)},"children":c[t]?"+":"-"})]}):"",(0,p.jsxs)(d.View,{"className":"api-page-btn ".concat(null==n.func?"api-page-btn-uncreate":""," ").concat(e.isAdvancedAPI(n.id)?"api-page-btn-advanced":""),"id":n.id,"onClick":function onClick(){e.submitData(a[t],n,t)},"children":[n.id,null!=n.callbackRes?(0,p.jsx)(m,{"testApi":n.id,"callbackRes":n.callbackRes}):""]})]},n.id)}))]})}}]),Index}(r.Component)},"51473":function(e,n,t){t.r(n),t.d(n,{"default":function(){return x}});var a,c=t(82163),o=t(6676),i=t(65599),s=t(97150),l=t(77483),r=t(26380),u=t(21065),d=t(6642),f=t(38036),p=t(63682),m=t(49141),h=t(66658),x=function(e){(0,s.Z)(Index,e);var n=(0,l.Z)(Index);function Index(){var e;(0,c.Z)(this,Index);for(var t=arguments.length,o=new Array(t),s=0;s<t;s++)o[s]=arguments[s];return e=n.call.apply(n,[this].concat(o)),(0,r.Z)((0,i.Z)(e),"state",{"list":[{"id":"createCameraContext","func":function func(n){m.n.consoleTest("createCameraContext"),a=(0,d.Y)(),m.n.consoleSuccess.call((0,i.Z)(e),a,n)}},{"id":"createCameraContext_onCameraFrame_暂不支持","func":function func(e){m.n.consoleTest("onCameraFrame"),a.onCameraFrame((function(e){m.n.consoleNormal("onCameraFrame callback :",e)}))}},{"id":"createCameraContext_setZoom_暂不支持","func":function func(n){m.n.consoleTest("setZoom"),a.setZoom({"zoom":70,"success":function success(t){m.n.consoleSuccess.call((0,i.Z)(e),t,n)},"fail":function fail(t){m.n.consoleFail.call((0,i.Z)(e),t,n)},"complete":function complete(t){m.n.consoleComplete.call((0,i.Z)(e),t,n)}}).then((function(t){m.n.consoleResult.call((0,i.Z)(e),t,n)}))}},{"id":"createCameraContext_startRecord","func":function func(n){m.n.consoleTest("startRecord"),a.startRecord({"success":function success(t){m.n.consoleSuccess.call((0,i.Z)(e),t,n)},"fail":function fail(t){m.n.consoleFail.call((0,i.Z)(e),t,n)},"complete":function complete(t){m.n.consoleComplete.call((0,i.Z)(e),t,n)},"timeoutCallback":function timeoutCallback(e){m.n.consoleNormal("startRecord callback :",e)}}).then((function(t){m.n.consoleResult.call((0,i.Z)(e),t,n)}))}},{"id":"createCameraContext_stopRecord","func":function func(n){m.n.consoleTest("stopRecord"),a.stopRecord({"success":function success(t){m.n.consoleSuccess.call((0,i.Z)(e),t,n)},"fail":function fail(t){m.n.consoleFail.call((0,i.Z)(e),t,n)},"complete":function complete(t){m.n.consoleComplete.call((0,i.Z)(e),t,n)}}).then((function(t){m.n.consoleResult.call((0,i.Z)(e),t,n)}))}},{"id":"createCameraContext_takePhoto","func":function func(n){m.n.consoleTest("takePhoto"),a.takePhoto({"quality":"normal","success":function success(t){m.n.consoleSuccess.call((0,i.Z)(e),t,n)},"fail":function fail(t){m.n.consoleFail.call((0,i.Z)(e),t,n)},"complete":function complete(t){m.n.consoleComplete.call((0,i.Z)(e),t,n)}}).then((function(t){m.n.consoleResult.call((0,i.Z)(e),t,n)}))}}]}),e}return(0,o.Z)(Index,[{"key":"render","value":function render(){var e=this.state.list;return(0,h.jsx)(f.View,{"className":"api-page","children":(0,h.jsx)(p.Z,{"buttonList":e})})}}]),Index}(u.Component)},"1834":function(e,n,t){var a=t(21065),c=Symbol.for("react.element"),o=Symbol.for("react.fragment"),i=Object.prototype.hasOwnProperty,s=a.__SECRET_INTERNALS_DO_NOT_USE_OR_YOU_WILL_BE_FIRED.ReactCurrentOwner,l={"key":!0,"ref":!0,"__self":!0,"__source":!0};function q(e,n,t){var a,o={},r=null,u=null;for(a in void 0!==t&&(r=""+t),void 0!==n.key&&(r=""+n.key),void 0!==n.ref&&(u=n.ref),n)i.call(n,a)&&!l.hasOwnProperty(a)&&(o[a]=n[a]);if(e&&e.defaultProps)for(a in n=e.defaultProps)void 0===o[a]&&(o[a]=n[a]);return{"$$typeof":c,"type":e,"key":r,"ref":u,"props":o,"_owner":s.current}}n.Fragment=o,n.jsx=q,n.jsxs=q},"66658":function(e,n,t){e.exports=t(1834)}}]);