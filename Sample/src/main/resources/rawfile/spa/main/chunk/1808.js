/*! For license information please see 1808.js.LICENSE.txt */
"use strict";(self.webpackJsonp=self.webpackJsonp||[]).push([[1808],{"6283":function(e,n,o){o.d(n,{"Z":function(){return h}});var c=o(3799),t=o(32461),s=o(16556),a=o(53202),l=o(28673),i=o(66306),u=o(98612),r=o(20874),f=o(955),m=o(53428),p=o(65169),d=function(e){(0,a.Z)(Index,e);var n=(0,l.Z)(Index);function Index(){var e;(0,c.Z)(this,Index);for(var o=arguments.length,t=new Array(o),a=0;a<o;a++)t[a]=arguments[a];return e=n.call.apply(n,[this].concat(t)),(0,i.Z)((0,s.Z)(e),"state",{}),(0,i.Z)((0,s.Z)(e),"stringify",(function(e){var n=new Map,o=JSON.stringify(e,(function(e,o){if(void 0===o)return"undefined";if("function"==typeof o)return"function";if("object"===(0,m.Z)(o)&&null!==o){if(n.has(o))return;n.set(o,o)}return o}));return n.clear(),o})),e}return(0,t.Z)(Index,[{"key":"render","value":function render(){var e=this.props,n=e.testApi,o=e.callbackRes;return(0,p.jsx)(f.View,{"className":"callback-content","children":(0,p.jsx)(f.View,{"className":"callback-res","id":"".concat(n,"-callback"),"children":this.stringify(o)})})}}]),Index}(u.Component),h=function(e){(0,a.Z)(Index,e);var n=(0,l.Z)(Index);function Index(){var e;(0,c.Z)(this,Index);for(var o=arguments.length,t=new Array(o),a=0;a<o;a++)t[a]=arguments[a];return e=n.call.apply(n,[this].concat(t)),(0,i.Z)((0,s.Z)(e),"state",{"inputData":[],"textareaControl":[],"hiddenNum":0}),(0,i.Z)((0,s.Z)(e),"changeData",(function(n,o){var c=e.state.inputData;try{c[o]=JSON.parse(n.detail.value)}catch(e){c[o]=n.detail.value}e.setState({"inputData":c})})),(0,i.Z)((0,s.Z)(e),"submitData",(function(e,n,o){null!=n.func&&("string"==typeof e?(0,r.CF)({"icon":"error","title":"请检查参数格式"}):null==e?n.func(o):n.func(o,e))})),(0,i.Z)((0,s.Z)(e),"minusHidden",(function(){var n=e.state.hiddenNum;n>0?e.setState({"hiddenNum":n-1}):(0,r.CF)({"title":"已全部显示"})})),(0,i.Z)((0,s.Z)(e),"addHidden",(function(){var n=e.state.hiddenNum;n<e.props.buttonList.length?e.setState({"hiddenNum":n+1}):(0,r.CF)({"title":"已全部隐藏"})})),(0,i.Z)((0,s.Z)(e),"hideTextarea",(function(n){var o=e.state.textareaControl;o[n]=!o[n],e.setState({"textareaControl":o})})),(0,i.Z)((0,s.Z)(e),"isAdvancedAPI",(function(e){try{return asAPIMap.get(e)}catch(e){return!1}})),e}return(0,t.Z)(Index,[{"key":"componentDidMount","value":function componentDidMount(){var e=this.props.buttonList,n=[],o=[];e.forEach((function(e){e.inputData?n.push(e.inputData):n.push(void 0),o.push(!0)})),this.setState({"inputData":n})}},{"key":"render","value":function render(){var e=this,n=this.props.buttonList,o=this.state,c=o.inputData,t=o.textareaControl,s=o.hiddenNum;return(0,p.jsxs)(f.View,{"className":"button-list","children":[(0,p.jsxs)(f.View,{"className":"hidden-control","children":[(0,p.jsx)(f.Text,{"children":"隐藏按钮"}),(0,p.jsxs)(f.View,{"className":"stepper","children":[(0,p.jsx)(f.View,{"className":"normal","onClick":this.minusHidden,"children":"-"}),(0,p.jsx)(f.View,{"className":"stepper-num","children":s}),(0,p.jsx)(f.View,{"className":"normal","onClick":this.addHidden,"children":"+"})]})]}),n.map((function(n,o){return(0,p.jsxs)(f.View,{"className":"api-page-btn-area ".concat(o<s?"api-page-btn-area-hidden":""),"children":[null!=c[o]?(0,p.jsxs)(f.View,{"className":"api-textarea-area","children":[(0,p.jsx)(f.Textarea,{"className":"api-input-area ".concat(t[o]?"api-input-area-hidden":""),"maxlength":-1,"id":"".concat(n.id,"-input"),"value":"string"==typeof c[o]?c[o]:JSON.stringify(c[o],null,2),"onInput":function onInput(n){e.changeData(n,o)}}),(0,p.jsx)(f.View,{"className":"textarea-control","onClick":function onClick(){e.hideTextarea(o)},"children":t[o]?"+":"-"})]}):"",(0,p.jsxs)(f.View,{"className":"api-page-btn ".concat(null==n.func?"api-page-btn-uncreate":""," ").concat(e.isAdvancedAPI(n.id)?"api-page-btn-advanced":""),"id":n.id,"onClick":function onClick(){e.submitData(c[o],n,o)},"children":[n.id,null!=n.callbackRes?(0,p.jsx)(d,{"testApi":n.id,"callbackRes":n.callbackRes}):""]})]},n.id)}))]})}}]),Index}(u.Component)},"1808":function(e,n,o){o.r(n),o.d(n,{"default":function(){return b}});var c=o(44038),t=o(3799),s=o(32461),a=o(16556),l=o(53202),i=o(28673),u=o(66306),r=o(98612),f=o(20939),m=o(87634),p=o(40861),d=o(33842),h=o(23211),g=o(75155),Z=o(63820),I=o(955),v=o(6283),N=o(52567),x=o(65169),b=function(e){(0,l.Z)(Index,e);var n=(0,i.Z)(Index);function Index(){var e;(0,t.Z)(this,Index);for(var o=arguments.length,s=new Array(o),l=0;l<o;l++)s[l]=arguments[l];return e=n.call.apply(n,[this].concat(s)),(0,u.Z)((0,a.Z)(e),"state",{"list":[{"id":"chooseImage","inputData":{"count":7,"sizeType":["original"],"sourceType":["album"],"imageId":""},"func":function func(n,o){N.n.consoleTest("chooseImage"),(0,f.I)((0,c.Z)((0,c.Z)({},o),{},{"success":function success(o){N.n.consoleSuccess.call((0,a.Z)(e),o,n)},"fail":function fail(o){N.n.consoleFail.call((0,a.Z)(e),o,n)},"complete":function complete(o){N.n.consoleComplete.call((0,a.Z)(e),o,n)}})).then((function(o){N.n.consoleResult.call((0,a.Z)(e),o,n)}))}},{"id":"previewImage","inputData":{"urls":["http://www.baidu.com/img/bdlogo.png","https://img1.baidu.com/it/u=698323844,3339950020&fm=253&app=138&size=w931&n=0&f=PNG&fmt=auto?sec=1694278800&t=60a09ae53f4ed052e28032d918935164","https://img1.baidu.com/it/u=698323844,3339950020&fm=253&app=138&size=w931&n=0&f=PNG&fmt=auto?sec=1694278800&t=60a09ae53f4ed052e28032d918935164"],"current":"","showmenu":!0,"referrerPolicy":"","imageMenuPrevent":!1},"func":function func(n,o){N.n.consoleTest("previewImage"),(0,m.E)((0,c.Z)((0,c.Z)({},o),{},{"success":function success(o){N.n.consoleSuccess.call((0,a.Z)(e),o,n)},"fail":function fail(o){N.n.consoleFail.call((0,a.Z)(e),o,n)},"complete":function complete(o){N.n.consoleComplete.call((0,a.Z)(e),o,n)}})).then((function(o){N.n.consoleResult.call((0,a.Z)(e),o,n)}))}},{"id":"getImageInfo","func":function func(n){N.n.consoleTest("getImageInfo"),(0,f.I)({"success":function success(o){(0,p.F)({"src":o.tempFilePaths[0],"success":function success(o){N.n.consoleSuccess.call((0,a.Z)(e),o,n)},"fail":function fail(o){N.n.consoleFail.call((0,a.Z)(e),o,n)},"complete":function complete(o){N.n.consoleComplete.call((0,a.Z)(e),o,n)}}).then((function(o){N.n.consoleResult.call((0,a.Z)(e),o,n)}))},"fail":function fail(e){N.n.consoleNormal("chooseImage fail:",e)},"complete":function complete(e){N.n.consoleNormal("chooseImage complete",e)}}).then((function(e){N.n.consoleNormal("chooseImage return",e)}))}},{"id":"saveImageToPhotosAlbum","func":function func(n){N.n.consoleTest("saveImageToPhotosAlbum"),(0,f.I)({"success":function success(o){N.n.consoleNormal("chooseImage success:",o),(0,d.F)({"filePath":o.tempFilePaths[0],"success":function success(o){N.n.consoleSuccess.call((0,a.Z)(e),o,n)},"fail":function fail(o){N.n.consoleFail.call((0,a.Z)(e),o,n)},"complete":function complete(o){N.n.consoleComplete.call((0,a.Z)(e),o,n)}}).then((function(o){N.n.consoleResult.call((0,a.Z)(e),o,n)}))},"fail":function fail(e){N.n.consoleNormal("chooseImage fail:",e)},"complete":function complete(e){N.n.consoleNormal("chooseImage complete",e)}}).then((function(e){N.n.consoleNormal("chooseImage return",e)}))}},{"id":"compressImage","func":function func(e){N.n.consoleTest("compressImage"),(0,f.I)({"success":function success(e){(0,h.h)({"quality":1,"src":e.tempFilePaths[0],"compressedWidth":300,"compressHeight":200,"success":function success(e){N.n.consoleNormal("compressImage success ",e),(0,d.F)({"filePath":e.tempFilePath,"success":function success(n){N.n.consoleNormal("saveImageToPhotosAlbum success ",n),(0,p.F)({"src":e.tempFilePath,"success":function success(e){N.n.consoleNormal("compress later:getImageInfo success ",e)},"fail":function fail(e){N.n.consoleNormal("compress later:getImageInfo fail ",e)},"complete":function complete(e){N.n.consoleNormal("compress later:getImageInfo complete ",e)}})},"fail":function fail(e){N.n.consoleNormal("saveImageToPhotosAlbum fail ",e)},"complete":function complete(e){N.n.consoleNormal("saveImageToPhotosAlbum complete ",e)}})},"fail":function fail(e){N.n.consoleFail(e)},"complete":function complete(e){N.n.consoleComplete(e)}}).then((function(e){N.n.consoleResult(e)}))}}).then((function(e){N.n.consoleNormal("compress before :chooseImage ret ",e.tempFiles[0].size)}))}},{"id":"previewMedia_image","func":function func(n){N.n.consoleTest("previewMedia_image"),(0,f.I)({"success":function success(o){N.n.consoleNormal("chooseImage success:",o),(0,g.g)({"sources":[{"url":o.tempFilePaths[0],"type":"image","poster":"test"}],"current":0,"showmenu":!1,"referrerPolicy":"origin","success":function success(o){N.n.consoleSuccess.call((0,a.Z)(e),o,n)},"fail":function fail(o){N.n.consoleFail.call((0,a.Z)(e),o,n)},"complete":function complete(o){N.n.consoleComplete.call((0,a.Z)(e),o,n)}}).then((function(o){N.n.consoleResult.call((0,a.Z)(e),o,n)}))},"fail":function fail(e){N.n.consoleNormal("chooseImage fail:",e)},"complete":function complete(e){N.n.consoleNormal("chooseImage complete",e)}}).then((function(e){N.n.consoleNormal("chooseImage return",e)}))}},{"id":"previewMedia_video_album","func":function func(n){N.n.consoleTest("previewMedia_video_album"),(0,Z.D)({"sourceType":["album"],"maxDuration":60,"camera":"back","success":function success(o){N.n.consoleNormal("chooseVideo success ",o),(0,g.g)({"sources":[{"url":o.tempFilePath,"type":"video","poster":"test_video"}],"success":function success(o){N.n.consoleSuccess.call((0,a.Z)(e),o,n)},"fail":function fail(o){N.n.consoleFail.call((0,a.Z)(e),o,n)},"complete":function complete(o){N.n.consoleComplete.call((0,a.Z)(e),o,n)}}).then((function(o){N.n.consoleResult.call((0,a.Z)(e),o,n)}))},"fail":function fail(e){N.n.consoleNormal("chooseVideo fail:",e)},"complete":function complete(e){N.n.consoleNormal("chooseVideo complete",e)}}).then((function(e){N.n.consoleNormal("chooseVideo return",e)}))}},{"id":"previewMedia_video_camera","func":function func(n){N.n.consoleTest("previewMedia_video_camera"),(0,Z.D)({"sourceType":["camera"],"maxDuration":60,"camera":"back","success":function success(o){N.n.consoleNormal("chooseVideo success ",o),(0,g.g)({"sources":[{"url":o.tempFilePath,"type":"video","poster":"test_video"}],"success":function success(o){N.n.consoleSuccess.call((0,a.Z)(e),o,n)},"fail":function fail(o){N.n.consoleFail.call((0,a.Z)(e),o,n)},"complete":function complete(o){N.n.consoleComplete.call((0,a.Z)(e),o,n)}}).then((function(o){N.n.consoleResult.call((0,a.Z)(e),o,n)}))},"fail":function fail(e){N.n.consoleNormal("chooseVideo fail:",e)},"complete":function complete(e){N.n.consoleNormal("chooseVideo complete",e)}}).then((function(e){N.n.consoleNormal("chooseVideo return",e)}))}}]}),e}return(0,s.Z)(Index,[{"key":"render","value":function render(){var e=this.state.list;return(0,x.jsx)(I.View,{"className":"api-page","children":(0,x.jsx)(v.Z,{"buttonList":e})})}}]),Index}(r.Component)},"55001":function(e,n,o){var c=o(98612),t=Symbol.for("react.element"),s=Symbol.for("react.fragment"),a=Object.prototype.hasOwnProperty,l=c.__SECRET_INTERNALS_DO_NOT_USE_OR_YOU_WILL_BE_FIRED.ReactCurrentOwner,i={"key":!0,"ref":!0,"__self":!0,"__source":!0};function q(e,n,o){var c,s={},u=null,r=null;for(c in void 0!==o&&(u=""+o),void 0!==n.key&&(u=""+n.key),void 0!==n.ref&&(r=n.ref),n)a.call(n,c)&&!i.hasOwnProperty(c)&&(s[c]=n[c]);if(e&&e.defaultProps)for(c in n=e.defaultProps)void 0===s[c]&&(s[c]=n[c]);return{"$$typeof":t,"type":e,"key":u,"ref":r,"props":s,"_owner":l.current}}n.Fragment=s,n.jsx=q,n.jsxs=q},"65169":function(e,n,o){e.exports=o(55001)}}]);