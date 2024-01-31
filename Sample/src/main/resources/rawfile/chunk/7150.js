/*! For license information please see 7150.js.LICENSE.txt */
"use strict";(self.webpackJsonp=self.webpackJsonp||[]).push([[7150],{"63682":function(n,e,t){t.d(e,{"Z":function(){return h}});var a=t(82163),i=t(6676),o=t(65599),c=t(97150),l=t(77483),s=t(26380),r=t(21065),u=t(35859),d=t(38036),f=t(91753),p=t(66658),m=function(n){(0,c.Z)(Index,n);var e=(0,l.Z)(Index);function Index(){var n;(0,a.Z)(this,Index);for(var t=arguments.length,i=new Array(t),c=0;c<t;c++)i[c]=arguments[c];return n=e.call.apply(e,[this].concat(i)),(0,s.Z)((0,o.Z)(n),"state",{}),(0,s.Z)((0,o.Z)(n),"stringify",(function(n){var e=new Map,t=JSON.stringify(n,(function(n,t){if(void 0===t)return"undefined";if("function"==typeof t)return"function";if("object"===(0,f.Z)(t)&&null!==t){if(e.has(t))return;e.set(t,t)}return t}));return e.clear(),t})),n}return(0,i.Z)(Index,[{"key":"render","value":function render(){var n=this.props,e=n.testApi,t=n.callbackRes;return(0,p.jsx)(d.View,{"className":"callback-content","children":(0,p.jsx)(d.View,{"className":"callback-res","id":"".concat(e,"-callback"),"children":this.stringify(t)})})}}]),Index}(r.Component),h=function(n){(0,c.Z)(Index,n);var e=(0,l.Z)(Index);function Index(){var n;(0,a.Z)(this,Index);for(var t=arguments.length,i=new Array(t),c=0;c<t;c++)i[c]=arguments[c];return n=e.call.apply(e,[this].concat(i)),(0,s.Z)((0,o.Z)(n),"state",{"inputData":[],"textareaControl":[],"hiddenNum":0}),(0,s.Z)((0,o.Z)(n),"changeData",(function(e,t){var a=n.state.inputData;try{a[t]=JSON.parse(e.detail.value)}catch(n){a[t]=e.detail.value}n.setState({"inputData":a})})),(0,s.Z)((0,o.Z)(n),"submitData",(function(n,e,t){null!=e.func&&("string"==typeof n?(0,u.CF)({"icon":"error","title":"请检查参数格式"}):null==n?e.func(t):e.func(t,n))})),(0,s.Z)((0,o.Z)(n),"minusHidden",(function(){var e=n.state.hiddenNum;e>0?n.setState({"hiddenNum":e-1}):(0,u.CF)({"title":"已全部显示"})})),(0,s.Z)((0,o.Z)(n),"addHidden",(function(){var e=n.state.hiddenNum;e<n.props.buttonList.length?n.setState({"hiddenNum":e+1}):(0,u.CF)({"title":"已全部隐藏"})})),(0,s.Z)((0,o.Z)(n),"hideTextarea",(function(e){var t=n.state.textareaControl;t[e]=!t[e],n.setState({"textareaControl":t})})),(0,s.Z)((0,o.Z)(n),"isAdvancedAPI",(function(n){try{return asAPIMap.get(n)}catch(n){return!1}})),n}return(0,i.Z)(Index,[{"key":"componentDidMount","value":function componentDidMount(){var n=this.props.buttonList,e=[],t=[];n.forEach((function(n){n.inputData?e.push(n.inputData):e.push(void 0),t.push(!0)})),this.setState({"inputData":e})}},{"key":"render","value":function render(){var n=this,e=this.props.buttonList,t=this.state,a=t.inputData,i=t.textareaControl,o=t.hiddenNum;return(0,p.jsxs)(d.View,{"className":"button-list","children":[(0,p.jsxs)(d.View,{"className":"hidden-control","children":[(0,p.jsx)(d.Text,{"children":"隐藏按钮"}),(0,p.jsxs)(d.View,{"className":"stepper","children":[(0,p.jsx)(d.View,{"className":"normal","onClick":this.minusHidden,"children":"-"}),(0,p.jsx)(d.View,{"className":"stepper-num","children":o}),(0,p.jsx)(d.View,{"className":"normal","onClick":this.addHidden,"children":"+"})]})]}),e.map((function(e,t){return(0,p.jsxs)(d.View,{"className":"api-page-btn-area ".concat(t<o?"api-page-btn-area-hidden":""),"children":[null!=a[t]?(0,p.jsxs)(d.View,{"className":"api-textarea-area","children":[(0,p.jsx)(d.Textarea,{"className":"api-input-area ".concat(i[t]?"api-input-area-hidden":""),"maxlength":-1,"id":"".concat(e.id,"-input"),"value":"string"==typeof a[t]?a[t]:JSON.stringify(a[t],null,2),"onInput":function onInput(e){n.changeData(e,t)}}),(0,p.jsx)(d.View,{"className":"textarea-control","onClick":function onClick(){n.hideTextarea(t)},"children":i[t]?"+":"-"})]}):"",(0,p.jsxs)(d.View,{"className":"api-page-btn ".concat(null==e.func?"api-page-btn-uncreate":""," ").concat(n.isAdvancedAPI(e.id)?"api-page-btn-advanced":""),"id":e.id,"onClick":function onClick(){n.submitData(a[t],e,t)},"children":[e.id,null!=e.callbackRes?(0,p.jsx)(m,{"testApi":e.id,"callbackRes":e.callbackRes}):""]})]},e.id)}))]})}}]),Index}(r.Component)},"27150":function(n,e,t){t.r(e),t.d(e,{"default":function(){return y}});var a=t(24497),i=t(82163),o=t(6676),c=t(65599),l=t(97150),s=t(77483),r=t(26380),u=t(21065),d=t(88978),f=t(38036),p=t(63682),m=t(49141),h=t(66658),x=["https://mdn.github.io/css-examples/web-fonts/VeraSeBd.ttf","https://puhuiti.oss-cn-hangzhou.aliyuncs.com/AlimamaShuHeiTi/AlimamaShuHeiTi-Bold/AlimamaShuHeiTi-Bold.ttf","https://mdn.alipayobjects.com/portal_mnwejl/afts/file/A*GG6cQ5B6iMsAAAAAAAAAAAAAAQAAAQ"],y=function(n){(0,l.Z)(Index,n);var e=(0,s.Z)(Index);function Index(){var n;(0,i.Z)(this,Index);for(var t=arguments.length,o=new Array(t),l=0;l<t;l++)o[l]=arguments[l];return n=e.call.apply(e,[this].concat(o)),(0,r.Z)((0,c.Z)(n),"state",{"list":[{"id":"loadFontFace0","inputData":{"family":"My Font","source":'url("'.concat(x[0],'")'),"global":!0,"desc":{"style":"normal","weight":"normal"}},"func":function func(e,t){m.n.consoleTest("Taro.loadFontFace"),(0,d.n)((0,a.Z)((0,a.Z)({},t),{},{"success":function success(t){m.n.consoleSuccess.call((0,c.Z)(n),t,e)},"fail":function fail(t){m.n.consoleFail.call((0,c.Z)(n),t,e)},"complete":function complete(t){m.n.consoleComplete.call((0,c.Z)(n),t,e)}}))}},{"id":"loadFontFace1","inputData":{"family":"My Font","source":'url("'.concat(x[1],'")'),"global":!0,"desc":{"style":"normal","weight":"Bold"}},"func":function func(e,t){m.n.consoleTest("Taro.loadFontFace"),(0,d.n)((0,a.Z)((0,a.Z)({},t),{},{"success":function success(t){m.n.consoleSuccess.call((0,c.Z)(n),t,e)},"fail":function fail(t){m.n.consoleFail.call((0,c.Z)(n),t,e)},"complete":function complete(t){m.n.consoleComplete.call((0,c.Z)(n),t,e)}}))}},{"id":"loadFontFace2","inputData":{"family":"My Font","source":'url("'.concat(x[2],'")'),"global":!0,"desc":{"style":"italic","weight":"normal"}},"func":function func(e,t){m.n.consoleTest("Taro.loadFontFace"),(0,d.n)((0,a.Z)((0,a.Z)({},t),{},{"success":function success(t){m.n.consoleSuccess.call((0,c.Z)(n),t,e)},"fail":function fail(t){m.n.consoleFail.call((0,c.Z)(n),t,e)},"complete":function complete(t){m.n.consoleComplete.call((0,c.Z)(n),t,e)}}))}}]}),n}return(0,o.Z)(Index,[{"key":"render","value":function render(){var n=this.state.list;return(0,h.jsxs)(f.View,{"className":"api-page","children":[(0,h.jsx)(f.Text,{"style":{"fontFamily":"My Font","fontStyle":"normal","fontWeight":"normal"},"children":"Taro三方框架(normal, normal)"}),(0,h.jsx)(f.Text,{"style":{"fontFamily":"My Font","fontStyle":"normal","fontWeight":"bold"},"children":"Taro三方框架(normal, bold)"}),(0,h.jsx)(f.Text,{"style":{"fontFamily":"My Font","fontStyle":"italic","fontWeight":"normal"},"children":"Taro三方框架(italic, normal)"}),(0,h.jsx)(p.Z,{"buttonList":n})]})}}]),Index}(u.Component)},"1834":function(n,e,t){var a=t(21065),i=Symbol.for("react.element"),o=Symbol.for("react.fragment"),c=Object.prototype.hasOwnProperty,l=a.__SECRET_INTERNALS_DO_NOT_USE_OR_YOU_WILL_BE_FIRED.ReactCurrentOwner,s={"key":!0,"ref":!0,"__self":!0,"__source":!0};function q(n,e,t){var a,o={},r=null,u=null;for(a in void 0!==t&&(r=""+t),void 0!==e.key&&(r=""+e.key),void 0!==e.ref&&(u=e.ref),e)c.call(e,a)&&!s.hasOwnProperty(a)&&(o[a]=e[a]);if(n&&n.defaultProps)for(a in e=n.defaultProps)void 0===o[a]&&(o[a]=e[a]);return{"$$typeof":i,"type":n,"key":r,"ref":u,"props":o,"_owner":l.current}}e.Fragment=o,e.jsx=q,e.jsxs=q},"66658":function(n,e,t){n.exports=t(1834)}}]);