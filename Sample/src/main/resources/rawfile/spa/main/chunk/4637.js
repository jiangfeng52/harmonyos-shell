/*! For license information please see 4637.js.LICENSE.txt */
"use strict";(self.webpackJsonp=self.webpackJsonp||[]).push([[4637],{"6283":function(e,n,c){c.d(n,{"Z":function(){return h}});var s=c(3799),l=c(32461),t=c(16556),o=c(53202),i=c(28673),a=c(66306),u=c(98612),f=c(20874),r=c(955),m=c(53428),p=c(65169),d=function(e){(0,o.Z)(Index,e);var n=(0,i.Z)(Index);function Index(){var e;(0,s.Z)(this,Index);for(var c=arguments.length,l=new Array(c),o=0;o<c;o++)l[o]=arguments[o];return e=n.call.apply(n,[this].concat(l)),(0,a.Z)((0,t.Z)(e),"state",{}),(0,a.Z)((0,t.Z)(e),"stringify",(function(e){var n=new Map,c=JSON.stringify(e,(function(e,c){if(void 0===c)return"undefined";if("function"==typeof c)return"function";if("object"===(0,m.Z)(c)&&null!==c){if(n.has(c))return;n.set(c,c)}return c}));return n.clear(),c})),e}return(0,l.Z)(Index,[{"key":"render","value":function render(){var e=this.props,n=e.testApi,c=e.callbackRes;return(0,p.jsx)(r.View,{"className":"callback-content","children":(0,p.jsx)(r.View,{"className":"callback-res","id":"".concat(n,"-callback"),"children":this.stringify(c)})})}}]),Index}(u.Component),h=function(e){(0,o.Z)(Index,e);var n=(0,i.Z)(Index);function Index(){var e;(0,s.Z)(this,Index);for(var c=arguments.length,l=new Array(c),o=0;o<c;o++)l[o]=arguments[o];return e=n.call.apply(n,[this].concat(l)),(0,a.Z)((0,t.Z)(e),"state",{"inputData":[],"textareaControl":[],"hiddenNum":0}),(0,a.Z)((0,t.Z)(e),"changeData",(function(n,c){var s=e.state.inputData;try{s[c]=JSON.parse(n.detail.value)}catch(e){s[c]=n.detail.value}e.setState({"inputData":s})})),(0,a.Z)((0,t.Z)(e),"submitData",(function(e,n,c){null!=n.func&&("string"==typeof e?(0,f.CF)({"icon":"error","title":"请检查参数格式"}):null==e?n.func(c):n.func(c,e))})),(0,a.Z)((0,t.Z)(e),"minusHidden",(function(){var n=e.state.hiddenNum;n>0?e.setState({"hiddenNum":n-1}):(0,f.CF)({"title":"已全部显示"})})),(0,a.Z)((0,t.Z)(e),"addHidden",(function(){var n=e.state.hiddenNum;n<e.props.buttonList.length?e.setState({"hiddenNum":n+1}):(0,f.CF)({"title":"已全部隐藏"})})),(0,a.Z)((0,t.Z)(e),"hideTextarea",(function(n){var c=e.state.textareaControl;c[n]=!c[n],e.setState({"textareaControl":c})})),(0,a.Z)((0,t.Z)(e),"isAdvancedAPI",(function(e){try{return asAPIMap.get(e)}catch(e){return!1}})),e}return(0,l.Z)(Index,[{"key":"componentDidMount","value":function componentDidMount(){var e=this.props.buttonList,n=[],c=[];e.forEach((function(e){e.inputData?n.push(e.inputData):n.push(void 0),c.push(!0)})),this.setState({"inputData":n})}},{"key":"render","value":function render(){var e=this,n=this.props.buttonList,c=this.state,s=c.inputData,l=c.textareaControl,t=c.hiddenNum;return(0,p.jsxs)(r.View,{"className":"button-list","children":[(0,p.jsxs)(r.View,{"className":"hidden-control","children":[(0,p.jsx)(r.Text,{"children":"隐藏按钮"}),(0,p.jsxs)(r.View,{"className":"stepper","children":[(0,p.jsx)(r.View,{"className":"normal","onClick":this.minusHidden,"children":"-"}),(0,p.jsx)(r.View,{"className":"stepper-num","children":t}),(0,p.jsx)(r.View,{"className":"normal","onClick":this.addHidden,"children":"+"})]})]}),n.map((function(n,c){return(0,p.jsxs)(r.View,{"className":"api-page-btn-area ".concat(c<t?"api-page-btn-area-hidden":""),"children":[null!=s[c]?(0,p.jsxs)(r.View,{"className":"api-textarea-area","children":[(0,p.jsx)(r.Textarea,{"className":"api-input-area ".concat(l[c]?"api-input-area-hidden":""),"maxlength":-1,"id":"".concat(n.id,"-input"),"value":"string"==typeof s[c]?s[c]:JSON.stringify(s[c],null,2),"onInput":function onInput(n){e.changeData(n,c)}}),(0,p.jsx)(r.View,{"className":"textarea-control","onClick":function onClick(){e.hideTextarea(c)},"children":l[c]?"+":"-"})]}):"",(0,p.jsxs)(r.View,{"className":"api-page-btn ".concat(null==n.func?"api-page-btn-uncreate":""," ").concat(e.isAdvancedAPI(n.id)?"api-page-btn-advanced":""),"id":n.id,"onClick":function onClick(){e.submitData(s[c],n,c)},"children":[n.id,null!=n.callbackRes?(0,p.jsx)(d,{"testApi":n.id,"callbackRes":n.callbackRes}):""]})]},n.id)}))]})}}]),Index}(u.Component)},"64637":function(e,n,c){c.r(n),c.d(n,{"default":function(){return _}});var s,l,t,o=c(44038),i=c(3799),a=c(32461),u=c(16556),f=c(53202),r=c(28673),m=c(66306),p=c(98612),d=c(20939),h=c(93798),F=c(19761),v=c(75439),y=c(41387),S=c(48010),Z=c(48573),N=c(36721),g=c(955),P=c(52567),x=c(6283),I=c(65169),_=function(e){(0,f.Z)(Index,e);var n=(0,r.Z)(Index);function Index(){var e;(0,i.Z)(this,Index);for(var c=arguments.length,a=new Array(c),f=0;f<c;f++)a[f]=arguments[f];return e=n.call.apply(n,[this].concat(a)),(0,m.Z)((0,u.Z)(e),"state",{"list":[{"id":"saveFile","func":function func(n){P.n.consoleTest("saveFile"),(0,d.I)({"success":function success(c){var s=c.tempFilePaths;(0,h.y)({"tempFilePath":s[0],"success":function success(c){P.n.consoleSuccess.call((0,u.Z)(e),c,n)},"fail":function fail(c){P.n.consoleFail.call((0,u.Z)(e),c,n)},"complete":function complete(c){P.n.consoleComplete.call((0,u.Z)(e),c,n)}}).then((function(c){P.n.consoleResult.call((0,u.Z)(e),c,n)}))}})}},{"id":"openDocument","inputData":{"filePath":"","showMenu":!1,"fileType":[]},"func":function func(n,c){P.n.consoleTest("openDocument"),(0,F.K)((0,o.Z)((0,o.Z)({},c),{},{"success":function success(c){P.n.consoleSuccess.call((0,u.Z)(e),c,n)},"fail":function fail(c){P.n.consoleFail.call((0,u.Z)(e),c,n)},"complete":function complete(c){P.n.consoleComplete.call((0,u.Z)(e),c,n)}}))}},{"id":"getSavedFileList","func":function func(n){P.n.consoleTest("getSavedFileList"),(0,v.r)({"success":function success(c){P.n.consoleSuccess.call((0,u.Z)(e),c,n)},"fail":function fail(c){P.n.consoleFail.call((0,u.Z)(e),c,n)},"complete":function complete(c){P.n.consoleComplete.call((0,u.Z)(e),c,n)}})}},{"id":"getSavedFileInfo","func":function func(n){P.n.consoleTest("getSavedFileInfo"),(0,d.I)({"success":function success(c){var s=c.tempFilePaths;(0,h.y)({"tempFilePath":s[0],"success":function success(c){P.n.consoleNormal("saveFile success ",c),(0,y.v)({"filePath":c.savedFilePath,"success":function success(c){P.n.consoleSuccess.call((0,u.Z)(e),c,n)},"fail":function fail(c){P.n.consoleFail.call((0,u.Z)(e),c,n)},"complete":function complete(c){P.n.consoleComplete.call((0,u.Z)(e),c,n)}}).then((function(c){P.n.consoleResult.call((0,u.Z)(e),c,n)}))},"fail":function fail(e){P.n.consoleNormal("saveFile fail ",e.errMsg)}})}})}},{"id":"getFileInfo","func":function func(n){P.n.consoleTest("getFileInfo"),(0,d.I)({"success":function success(c){var s=c.tempFilePaths;(0,h.y)({"tempFilePath":s[0],"success":function success(c){P.n.consoleNormal("saveFile success ",c),(0,S.h)({"filePath":c.savedFilePath,"success":function success(c){P.n.consoleSuccess.call((0,u.Z)(e),c,n)},"fail":function fail(c){P.n.consoleFail.call((0,u.Z)(e),c,n)},"complete":function complete(c){P.n.consoleComplete.call((0,u.Z)(e),c,n)}}).then((function(c){P.n.consoleResult.call((0,u.Z)(e),c,n)}))},"fail":function fail(e){P.n.consoleNormal("saveFile fail ",e.errMsg)}})}})}},{"id":"removeSavedFile","func":function func(n){P.n.consoleTest("removeSavedFile"),(0,v.r)({"success":function success(c){P.n.consoleNormal("getSavedFileList success ",c),c.fileList.length>0&&(0,Z.b)({"filePath":c.fileList[0].filePath,"success":function success(c){P.n.consoleSuccess.call((0,u.Z)(e),c,n)},"fail":function fail(c){P.n.consoleFail.call((0,u.Z)(e),c,n)},"complete":function complete(c){P.n.consoleComplete.call((0,u.Z)(e),c,n)}}).then((function(c){P.n.consoleResult.call((0,u.Z)(e),c,n)}))}})}},{"id":"getFileSystemManager","func":function func(n){P.n.consoleTest("getFileSystemManager"),s=(0,N.l)(),P.n.consoleResult.call((0,u.Z)(e),s,n)}},{"id":"fileSystem_access","func":function func(n){P.n.consoleTest("fileSystem_access"),(0,d.I)({"success":function success(c){var l=c.tempFilePaths;(0,h.y)({"tempFilePath":l[0],"filePath":"D:/common","success":function success(c){P.n.consoleNormal("saveFile success ",c),s.access({"path":c.savedFilePath,"success":function success(c){P.n.consoleSuccess.call((0,u.Z)(e),c,n)},"fail":function fail(c){P.n.consoleFail.call((0,u.Z)(e),c,n)},"complete":function complete(c){P.n.consoleComplete.call((0,u.Z)(e),c,n)}})},"fail":function fail(e){P.n.consoleNormal("saveFile fail ",e.errMsg)},"complete":function complete(e){P.n.consoleNormal("saveFile complete ",e)}})}})}},{"id":"fileSystem_accessSync","func":function func(e){P.n.consoleTest("fileSystem_accessSync"),(0,d.I)({"success":function success(e){var n=e.tempFilePaths;(0,h.y)({"tempFilePath":n[0],"filePath":"D:/common","success":function success(e){P.n.consoleNormal("saveFile success ",e),s.accessSync(e.savedFilePath),P.n.consoleNormal("accessSync success ")},"fail":function fail(e){P.n.consoleNormal("saveFile fail ",e.errMsg)},"complete":function complete(e){P.n.consoleNormal("saveFile complete ",e)}})}})}},{"id":"fileSystem_appendFile","func":function func(n){P.n.consoleTest("fileSystem_appendFile"),(0,d.I)({"success":function success(c){var l=c.tempFilePaths;(0,h.y)({"tempFilePath":l[0],"filePath":"D:/common","success":function success(c){P.n.consoleNormal("saveFile success ",c),s.appendFile({"data":"append test","filePath":c.savedFilePath,"encoding":"utf8","success":function success(c){P.n.consoleSuccess.call((0,u.Z)(e),c,n)},"fail":function fail(c){P.n.consoleFail.call((0,u.Z)(e),c,n)},"complete":function complete(c){P.n.consoleComplete.call((0,u.Z)(e),c,n)}})},"fail":function fail(e){P.n.consoleNormal("saveFile fail ",e.errMsg)},"complete":function complete(e){P.n.consoleNormal("saveFile complete ",e)}})}})}},{"id":"fileSystem_appendFileSync","func":function func(e){P.n.consoleTest("fileSystem_appendFileSync"),(0,d.I)({"success":function success(e){var n=e.tempFilePaths;(0,h.y)({"tempFilePath":n[0],"filePath":"D:/common","success":function success(e){P.n.consoleNormal("saveFile success ",e),s.appendFileSync(e.savedFilePath,"sync test","utf8"),P.n.consoleNormal("appendFileSync success ")},"fail":function fail(e){P.n.consoleNormal("saveFile fail ",e.errMsg)},"complete":function complete(e){P.n.consoleNormal("saveFile complete ",e)}})}})}},{"id":"fileSystem_open","func":function func(n){P.n.consoleTest("fileSystem_open"),(0,d.I)({"success":function success(c){var l=c.tempFilePaths;(0,h.y)({"tempFilePath":l[0],"filePath":"D:/common","success":function success(c){P.n.consoleNormal("saveFile success ",c),s.open({"filePath":c.savedFilePath,"flag":"r","success":function success(c){P.n.consoleSuccess.call((0,u.Z)(e),c,n)},"fail":function fail(c){P.n.consoleFail.call((0,u.Z)(e),c,n)},"complete":function complete(c){P.n.consoleComplete.call((0,u.Z)(e),c,n)}})},"fail":function fail(e){P.n.consoleNormal("saveFile fail ",e.errMsg)},"complete":function complete(e){P.n.consoleNormal("saveFile complete ",e)}})}})}},{"id":"fileSystem_close","func":function func(n){P.n.consoleTest("fileSystem_close"),s.close({"fd":l,"success":function success(c){P.n.consoleSuccess.call((0,u.Z)(e),c,n)},"fail":function fail(c){P.n.consoleFail.call((0,u.Z)(e),c,n)},"complete":function complete(c){P.n.consoleComplete.call((0,u.Z)(e),c,n)}})}},{"id":"fileSystem_openSync","func":function func(e){P.n.consoleTest("fileSystem_openSync"),(0,d.I)({"success":function success(e){var n=e.tempFilePaths;(0,h.y)({"tempFilePath":n[0],"filePath":"D:/common","success":function success(e){P.n.consoleNormal("saveFile success ",e),t=s.openSync({"filePath":e.savedFilePath,"flag":"r"}),P.n.consoleNormal("openSync success ",t)},"fail":function fail(e){P.n.consoleNormal("saveFile fail ",e.errMsg)},"complete":function complete(e){P.n.consoleNormal("saveFile complete ",e)}})}})}},{"id":"fileSystem_closeSync","func":function func(e){P.n.consoleTest("fileSystem_closeSync"),s.closeSync({"fd":t}),P.n.consoleNormal("closeSync success ",t)}},{"id":"fileSystem_fstat","func":function func(n){P.n.consoleTest("fileSystem_fstat"),s.fstat({"fd":l,"success":function success(c){P.n.consoleSuccess.call((0,u.Z)(e),c,n)},"fail":function fail(c){P.n.consoleFail.call((0,u.Z)(e),c,n)},"complete":function complete(c){P.n.consoleComplete.call((0,u.Z)(e),c,n)}})}},{"id":"fileSystem_fstatSync_暂不支持","func":function func(e){P.n.consoleTest("fileSystem_fstatSync"),s.fstatSync({"fd":l}),P.n.consoleNormal("closeSync success ",l)}},{"id":"fileSystem_getFileInfo","func":function func(n){P.n.consoleTest("fileSystem_getFileInfo"),(0,d.I)({"success":function success(c){var l=c.tempFilePaths;(0,h.y)({"tempFilePath":l[0],"success":function success(c){P.n.consoleNormal("saveFile success ",c),s.getFileInfo({"filePath":c.savedFilePath,"success":function success(c){P.n.consoleSuccess.call((0,u.Z)(e),c,n)},"fail":function fail(c){P.n.consoleFail.call((0,u.Z)(e),c,n)},"complete":function complete(c){P.n.consoleComplete.call((0,u.Z)(e),c,n)}})},"fail":function fail(e){P.n.consoleNormal("saveFile fail ",e.errMsg)},"complete":function complete(e){P.n.consoleNormal("saveFile complete ",e)}})}})}},{"id":"fileSystem_readFile","inputData":{"encoding":"","position":0,"length":1e3},"func":function func(n,c){P.n.consoleTest("fileSystem_readFile"),(0,d.I)({"success":function success(l){s.readFile((0,o.Z)((0,o.Z)({"filePath":l.tempFilePaths[0]},c),{},{"success":function success(c){P.n.consoleSuccess.call((0,u.Z)(e),c,n)},"fail":function fail(c){P.n.consoleFail.call((0,u.Z)(e),c,n)},"complete":function complete(c){P.n.consoleComplete.call((0,u.Z)(e),c,n)}}))}})}},{"id":"fileSystem_readFileSync","inputData":{"encoding":"","position":0,"length":1e3},"func":function func(n,c){P.n.consoleTest("fileSystem_readFileSync"),(0,d.I)({"success":function success(l){var t=s.readFileSync(l.tempFilePaths[0],c.encoding,c.position,c.length);P.n.consoleResult.call((0,u.Z)(e),t,n)}})}}]}),e}return(0,a.Z)(Index,[{"key":"render","value":function render(){var e=this.state.list;return(0,I.jsx)(g.View,{"className":"api-page","children":(0,I.jsx)(x.Z,{"buttonList":e})})}}]),Index}(p.Component)},"55001":function(e,n,c){var s=c(98612),l=Symbol.for("react.element"),t=Symbol.for("react.fragment"),o=Object.prototype.hasOwnProperty,i=s.__SECRET_INTERNALS_DO_NOT_USE_OR_YOU_WILL_BE_FIRED.ReactCurrentOwner,a={"key":!0,"ref":!0,"__self":!0,"__source":!0};function q(e,n,c){var s,t={},u=null,f=null;for(s in void 0!==c&&(u=""+c),void 0!==n.key&&(u=""+n.key),void 0!==n.ref&&(f=n.ref),n)o.call(n,s)&&!a.hasOwnProperty(s)&&(t[s]=n[s]);if(e&&e.defaultProps)for(s in n=e.defaultProps)void 0===t[s]&&(t[s]=n[s]);return{"$$typeof":l,"type":e,"key":u,"ref":f,"props":t,"_owner":i.current}}n.Fragment=t,n.jsx=q,n.jsxs=q},"65169":function(e,n,c){e.exports=c(55001)}}]);