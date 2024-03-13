/*! For license information please see 5148.js.LICENSE.txt */
"use strict";(self.webpackJsonp=self.webpackJsonp||[]).push([[5148],{"6283":function(n,e,t){t.d(e,{"Z":function(){return x}});var a=t(3799),i=t(32461),c=t(16556),r=t(53202),s=t(28673),o=t(66306),l=t(98612),u=t(20874),d=t(955),p=t(53428),f=t(65169),h=function(n){(0,r.Z)(Index,n);var e=(0,s.Z)(Index);function Index(){var n;(0,a.Z)(this,Index);for(var t=arguments.length,i=new Array(t),r=0;r<t;r++)i[r]=arguments[r];return n=e.call.apply(e,[this].concat(i)),(0,o.Z)((0,c.Z)(n),"state",{}),(0,o.Z)((0,c.Z)(n),"stringify",(function(n){var e=new Map,t=JSON.stringify(n,(function(n,t){if(void 0===t)return"undefined";if("function"==typeof t)return"function";if("object"===(0,p.Z)(t)&&null!==t){if(e.has(t))return;e.set(t,t)}return t}));return e.clear(),t})),n}return(0,i.Z)(Index,[{"key":"render","value":function render(){var n=this.props,e=n.testApi,t=n.callbackRes;return(0,f.jsx)(d.View,{"className":"callback-content","children":(0,f.jsx)(d.View,{"className":"callback-res","id":"".concat(e,"-callback"),"children":this.stringify(t)})})}}]),Index}(l.Component),x=function(n){(0,r.Z)(Index,n);var e=(0,s.Z)(Index);function Index(){var n;(0,a.Z)(this,Index);for(var t=arguments.length,i=new Array(t),r=0;r<t;r++)i[r]=arguments[r];return n=e.call.apply(e,[this].concat(i)),(0,o.Z)((0,c.Z)(n),"state",{"inputData":[],"textareaControl":[],"hiddenNum":0}),(0,o.Z)((0,c.Z)(n),"changeData",(function(e,t){var a=n.state.inputData;try{a[t]=JSON.parse(e.detail.value)}catch(n){a[t]=e.detail.value}n.setState({"inputData":a})})),(0,o.Z)((0,c.Z)(n),"submitData",(function(n,e,t){null!=e.func&&("string"==typeof n?(0,u.CF)({"icon":"error","title":"请检查参数格式"}):null==n?e.func(t):e.func(t,n))})),(0,o.Z)((0,c.Z)(n),"minusHidden",(function(){var e=n.state.hiddenNum;e>0?n.setState({"hiddenNum":e-1}):(0,u.CF)({"title":"已全部显示"})})),(0,o.Z)((0,c.Z)(n),"addHidden",(function(){var e=n.state.hiddenNum;e<n.props.buttonList.length?n.setState({"hiddenNum":e+1}):(0,u.CF)({"title":"已全部隐藏"})})),(0,o.Z)((0,c.Z)(n),"hideTextarea",(function(e){var t=n.state.textareaControl;t[e]=!t[e],n.setState({"textareaControl":t})})),(0,o.Z)((0,c.Z)(n),"isAdvancedAPI",(function(n){try{return asAPIMap.get(n)}catch(n){return!1}})),n}return(0,i.Z)(Index,[{"key":"componentDidMount","value":function componentDidMount(){var n=this.props.buttonList,e=[],t=[];n.forEach((function(n){n.inputData?e.push(n.inputData):e.push(void 0),t.push(!0)})),this.setState({"inputData":e})}},{"key":"render","value":function render(){var n=this,e=this.props.buttonList,t=this.state,a=t.inputData,i=t.textareaControl,c=t.hiddenNum;return(0,f.jsxs)(d.View,{"className":"button-list","children":[(0,f.jsxs)(d.View,{"className":"hidden-control","children":[(0,f.jsx)(d.Text,{"children":"隐藏按钮"}),(0,f.jsxs)(d.View,{"className":"stepper","children":[(0,f.jsx)(d.View,{"className":"normal","onClick":this.minusHidden,"children":"-"}),(0,f.jsx)(d.View,{"className":"stepper-num","children":c}),(0,f.jsx)(d.View,{"className":"normal","onClick":this.addHidden,"children":"+"})]})]}),e.map((function(e,t){return(0,f.jsxs)(d.View,{"className":"api-page-btn-area ".concat(t<c?"api-page-btn-area-hidden":""),"children":[null!=a[t]?(0,f.jsxs)(d.View,{"className":"api-textarea-area","children":[(0,f.jsx)(d.Textarea,{"className":"api-input-area ".concat(i[t]?"api-input-area-hidden":""),"maxlength":-1,"id":"".concat(e.id,"-input"),"value":"string"==typeof a[t]?a[t]:JSON.stringify(a[t],null,2),"onInput":function onInput(e){n.changeData(e,t)}}),(0,f.jsx)(d.View,{"className":"textarea-control","onClick":function onClick(){n.hideTextarea(t)},"children":i[t]?"+":"-"})]}):"",(0,f.jsxs)(d.View,{"className":"api-page-btn ".concat(null==e.func?"api-page-btn-uncreate":""," ").concat(n.isAdvancedAPI(e.id)?"api-page-btn-advanced":""),"id":e.id,"onClick":function onClick(){n.submitData(a[t],e,t)},"children":[e.id,null!=e.callbackRes?(0,f.jsx)(h,{"testApi":e.id,"callbackRes":e.callbackRes}):""]})]},e.id)}))]})}}]),Index}(l.Component)},"55148":function(n,e,t){t.r(e),t.d(e,{"default":function(){return Z}});var a=t(44038),i=t(3799),c=t(32461),r=t(16556),s=t(53202),o=t(28673),l=t(66306),u=t(98612),d=t(23578),p=t(36546),f=t(955),h=t(6283),x=t(52567),m=t(65169),Z=function(n){(0,s.Z)(Index,n);var e=(0,o.Z)(Index);function Index(){var n;(0,i.Z)(this,Index);for(var t=arguments.length,c=new Array(t),s=0;s<t;s++)c[s]=arguments[s];return n=e.call.apply(e,[this].concat(c)),(0,l.Z)((0,r.Z)(n),"state",{"list":[{"id":"openSetting","inputData":{"withSubscriptions":!1},"func":function func(e,t){x.n.consoleTest("Taro.openSetting"),(0,d.a)((0,a.Z)((0,a.Z)({},t),{},{"success":function success(t){x.n.consoleSuccess.call((0,r.Z)(n),t,e)},"fail":function fail(t){x.n.consoleFail.call((0,r.Z)(n),t,e)},"complete":function complete(t){x.n.consoleComplete.call((0,r.Z)(n),t,e)}}))}},{"id":"getSetting","inputData":{"withSubscriptions":!1},"func":function func(e,t){x.n.consoleTest("Taro.getSetting"),(0,p.$)((0,a.Z)((0,a.Z)({},t),{},{"success":function success(t){x.n.consoleSuccess.call((0,r.Z)(n),t,e)},"fail":function fail(t){x.n.consoleFail.call((0,r.Z)(n),t,e)},"complete":function complete(t){x.n.consoleComplete.call((0,r.Z)(n),t,e)}}))}},{"id":"AuthSetting","func":null},{"id":"SubscriptionsSetting","func":null}]}),n}return(0,c.Z)(Index,[{"key":"render","value":function render(){var n=this.state.list;return(0,m.jsx)(f.View,{"className":"api-page","children":(0,m.jsx)(h.Z,{"buttonList":n})})}}]),Index}(u.Component)},"55001":function(n,e,t){var a=t(98612),i=Symbol.for("react.element"),c=Symbol.for("react.fragment"),r=Object.prototype.hasOwnProperty,s=a.__SECRET_INTERNALS_DO_NOT_USE_OR_YOU_WILL_BE_FIRED.ReactCurrentOwner,o={"key":!0,"ref":!0,"__self":!0,"__source":!0};function q(n,e,t){var a,c={},l=null,u=null;for(a in void 0!==t&&(l=""+t),void 0!==e.key&&(l=""+e.key),void 0!==e.ref&&(u=e.ref),e)r.call(e,a)&&!o.hasOwnProperty(a)&&(c[a]=e[a]);if(n&&n.defaultProps)for(a in e=n.defaultProps)void 0===c[a]&&(c[a]=e[a]);return{"$$typeof":i,"type":n,"key":l,"ref":u,"props":c,"_owner":s.current}}e.Fragment=c,e.jsx=q,e.jsxs=q},"65169":function(n,e,t){n.exports=t(55001)}}]);