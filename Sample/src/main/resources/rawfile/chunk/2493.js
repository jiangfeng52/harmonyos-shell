/*! For license information please see 2493.js.LICENSE.txt */
"use strict";(self.webpackJsonp=self.webpackJsonp||[]).push([[2493],{"63682":function(e,n,o){o.d(n,{"Z":function(){return h}});var c=o(82163),t=o(6676),a=o(65599),s=o(97150),i=o(77483),l=o(26380),u=o(21065),r=o(35859),d=o(38036),f=o(91753),p=o(66658),m=function(e){(0,s.Z)(Index,e);var n=(0,i.Z)(Index);function Index(){var e;(0,c.Z)(this,Index);for(var o=arguments.length,t=new Array(o),s=0;s<o;s++)t[s]=arguments[s];return e=n.call.apply(n,[this].concat(t)),(0,l.Z)((0,a.Z)(e),"state",{}),(0,l.Z)((0,a.Z)(e),"stringify",(function(e){var n=new Map,o=JSON.stringify(e,(function(e,o){if(void 0===o)return"undefined";if("function"==typeof o)return"function";if("object"===(0,f.Z)(o)&&null!==o){if(n.has(o))return;n.set(o,o)}return o}));return n.clear(),o})),e}return(0,t.Z)(Index,[{"key":"render","value":function render(){var e=this.props,n=e.testApi,o=e.callbackRes;return(0,p.jsx)(d.View,{"className":"callback-content","children":(0,p.jsx)(d.View,{"className":"callback-res","id":"".concat(n,"-callback"),"children":this.stringify(o)})})}}]),Index}(u.Component),h=function(e){(0,s.Z)(Index,e);var n=(0,i.Z)(Index);function Index(){var e;(0,c.Z)(this,Index);for(var o=arguments.length,t=new Array(o),s=0;s<o;s++)t[s]=arguments[s];return e=n.call.apply(n,[this].concat(t)),(0,l.Z)((0,a.Z)(e),"state",{"inputData":[],"textareaControl":[],"hiddenNum":0}),(0,l.Z)((0,a.Z)(e),"changeData",(function(n,o){var c=e.state.inputData;try{c[o]=JSON.parse(n.detail.value)}catch(e){c[o]=n.detail.value}e.setState({"inputData":c})})),(0,l.Z)((0,a.Z)(e),"submitData",(function(e,n,o){null!=n.func&&("string"==typeof e?(0,r.CF)({"icon":"error","title":"请检查参数格式"}):null==e?n.func(o):n.func(o,e))})),(0,l.Z)((0,a.Z)(e),"minusHidden",(function(){var n=e.state.hiddenNum;n>0?e.setState({"hiddenNum":n-1}):(0,r.CF)({"title":"已全部显示"})})),(0,l.Z)((0,a.Z)(e),"addHidden",(function(){var n=e.state.hiddenNum;n<e.props.buttonList.length?e.setState({"hiddenNum":n+1}):(0,r.CF)({"title":"已全部隐藏"})})),(0,l.Z)((0,a.Z)(e),"hideTextarea",(function(n){var o=e.state.textareaControl;o[n]=!o[n],e.setState({"textareaControl":o})})),(0,l.Z)((0,a.Z)(e),"isAdvancedAPI",(function(e){try{return asAPIMap.get(e)}catch(e){return!1}})),e}return(0,t.Z)(Index,[{"key":"componentDidMount","value":function componentDidMount(){var e=this.props.buttonList,n=[],o=[];e.forEach((function(e){e.inputData?n.push(e.inputData):n.push(void 0),o.push(!0)})),this.setState({"inputData":n})}},{"key":"render","value":function render(){var e=this,n=this.props.buttonList,o=this.state,c=o.inputData,t=o.textareaControl,a=o.hiddenNum;return(0,p.jsxs)(d.View,{"className":"button-list","children":[(0,p.jsxs)(d.View,{"className":"hidden-control","children":[(0,p.jsx)(d.Text,{"children":"隐藏按钮"}),(0,p.jsxs)(d.View,{"className":"stepper","children":[(0,p.jsx)(d.View,{"className":"normal","onClick":this.minusHidden,"children":"-"}),(0,p.jsx)(d.View,{"className":"stepper-num","children":a}),(0,p.jsx)(d.View,{"className":"normal","onClick":this.addHidden,"children":"+"})]})]}),n.map((function(n,o){return(0,p.jsxs)(d.View,{"className":"api-page-btn-area ".concat(o<a?"api-page-btn-area-hidden":""),"children":[null!=c[o]?(0,p.jsxs)(d.View,{"className":"api-textarea-area","children":[(0,p.jsx)(d.Textarea,{"className":"api-input-area ".concat(t[o]?"api-input-area-hidden":""),"maxlength":-1,"id":"".concat(n.id,"-input"),"value":"string"==typeof c[o]?c[o]:JSON.stringify(c[o],null,2),"onInput":function onInput(n){e.changeData(n,o)}}),(0,p.jsx)(d.View,{"className":"textarea-control","onClick":function onClick(){e.hideTextarea(o)},"children":t[o]?"+":"-"})]}):"",(0,p.jsxs)(d.View,{"className":"api-page-btn ".concat(null==n.func?"api-page-btn-uncreate":""," ").concat(e.isAdvancedAPI(n.id)?"api-page-btn-advanced":""),"id":n.id,"onClick":function onClick(){e.submitData(c[o],n,o)},"children":[n.id,null!=n.callbackRes?(0,p.jsx)(m,{"testApi":n.id,"callbackRes":n.callbackRes}):""]})]},n.id)}))]})}}]),Index}(u.Component)},"52493":function(e,n,o){o.r(n),o.d(n,{"default":function(){return _}});var c,t=o(24497),a=o(82163),s=o(6676),i=o(65599),l=o(97150),u=o(77483),r=o(26380),d=o(21065),f=o(19703),p=o(26218),m=o(89850),h=o(90693),x=o(42512),Z=o(41948),v=o(94949),y=o(38036),b=o(63682),N=o(49141),k=o(66658),_=function(e){(0,l.Z)(Index,e);var n=(0,u.Z)(Index);function Index(){var e;(0,a.Z)(this,Index);for(var o=arguments.length,s=new Array(o),l=0;l<o;l++)s[l]=arguments[l];return e=n.call.apply(n,[this].concat(s)),(0,r.Z)((0,i.Z)(e),"state",{"list":[{"id":"saveVideoToPhotosAlbum","inputData":{"sourceType":["album"],"maxDuration":60,"camera":"back","compressed":!1},"func":function func(n,o){N.n.consoleTest("saveVideoToPhotosAlbum"),(0,f.D)((0,t.Z)((0,t.Z)({},o),{},{"success":function success(o){N.n.consoleNormal("chooseVideo success ",o),(0,p.x)({"filePath":o.tempFilePath,"success":function success(o){N.n.consoleSuccess.call((0,i.Z)(e),o,n)},"fail":function fail(o){N.n.consoleFail.call((0,i.Z)(e),o,n)},"complete":function complete(o){N.n.consoleComplete.call((0,i.Z)(e),o,n)}}).then((function(o){N.n.consoleResult.call((0,i.Z)(e),o,n)}))},"fail":function fail(e){N.n.consoleNormal("chooseVideo fail:",e)},"complete":function complete(e){N.n.consoleNormal("chooseVideo complete",e)}})).then((function(e){N.n.consoleNormal("chooseVideo return",e)}))}},{"id":"openVideoEditor_暂不支持","func":function func(n){N.n.consoleTest("openVideoEditor"),(0,f.D)({"sourceType":["album","camera"],"maxDuration":60,"camera":"back","success":function success(o){(0,m.J)({"filePath":o.tempFilePath,"success":function success(o){N.n.consoleSuccess.call((0,i.Z)(e),o,n)},"fail":function fail(o){N.n.consoleFail.call((0,i.Z)(e),o,n)},"complete":function complete(o){N.n.consoleComplete.call((0,i.Z)(e),o,n)}}).then((function(o){N.n.consoleResult.call((0,i.Z)(e),o,n)}))},"fail":function fail(e){N.n.consoleNormal("chooseVideo fail:",e)},"complete":function complete(e){N.n.consoleNormal("chooseVideo complete",e)}}).then((function(e){N.n.consoleNormal("chooseVideo return",e)}))}},{"id":"getVideoInfo","func":function func(n){N.n.consoleTest("getVideoInfo"),(0,f.D)({"sourceType":["album"],"maxDuration":60,"camera":"back","compressed":!1,"success":function success(o){N.n.consoleNormal("chooseVideo success ",o),(0,h.$)({"src":o.tempFilePath,"success":function success(o){N.n.consoleSuccess.call((0,i.Z)(e),o,n)},"fail":function fail(o){N.n.consoleFail.call((0,i.Z)(e),o,n)},"complete":function complete(o){N.n.consoleComplete.call((0,i.Z)(e),o,n)}}).then((function(o){N.n.consoleResult.call((0,i.Z)(e),o,n)}))},"fail":function fail(e){N.n.consoleNormal("chooseVideo fail:",e)},"complete":function complete(e){N.n.consoleNormal("chooseVideo complete",e)}}).then((function(e){N.n.consoleNormal("chooseVideo return",e)}))}},{"id":"compressVideo_暂不支持","inputData":{"quality":"high","bitrate":1032,"fps":24,"resolution":.5},"func":function func(n,o){N.n.consoleTest("compressVideo"),(0,f.D)({"sourceType":["album","camera"],"maxDuration":60,"camera":"back","compressed":!1,"success":function success(c){(0,x.L)((0,t.Z)((0,t.Z)({"src":c.tempFilePath},o),{},{"success":function success(o){N.n.consoleSuccess.call((0,i.Z)(e),o,n)},"fail":function fail(o){N.n.consoleFail.call((0,i.Z)(e),o,n)},"complete":function complete(o){N.n.consoleComplete.call((0,i.Z)(e),o,n)}})).then((function(o){N.n.consoleResult.call((0,i.Z)(e),o,n)}))},"fail":function fail(e){N.n.consoleNormal("chooseVideo fail:",e)},"complete":function complete(e){N.n.consoleNormal("chooseVideo complete",e)}}).then((function(e){N.n.consoleNormal("chooseVideo return",e)}))}},{"id":"chooseVideo","inputData":{"camera":"","compressed":!1,"sourceType":["album"],"maxDuration":30},"func":function func(n,o){N.n.consoleTest("chooseVideo"),(0,f.D)((0,t.Z)((0,t.Z)({},o),{},{"success":function success(o){N.n.consoleSuccess.call((0,i.Z)(e),o,n)},"fail":function fail(o){N.n.consoleFail.call((0,i.Z)(e),o,n)},"complete":function complete(o){N.n.consoleComplete.call((0,i.Z)(e),o,n)}})).then((function(o){N.n.consoleResult.call((0,i.Z)(e),o,n)}))}},{"id":"chooseMedia","inputData":{"count":9,"mediaType":["image"],"sourceType":["album","camera"],"maxDuration":30,"sizeType":["original","compressed"],"camera":"back","mediaId":""},"func":function func(n,o){N.n.consoleTest("chooseMedia"),(0,Z.K)((0,t.Z)((0,t.Z)({},o),{},{"success":function success(o){N.n.consoleSuccess.call((0,i.Z)(e),o,n)},"fail":function fail(o){N.n.consoleFail.call((0,i.Z)(e),o,n)}})).then((function(o){N.n.consoleResult.call((0,i.Z)(e),o,n)}))}},{"id":"createVideoContext","func":function func(n){N.n.consoleTest("createVideoContext"),c=(0,v.Au)("myVideo"),N.n.consoleResult.call((0,i.Z)(e),c,n)}},{"id":"video_exitBackgroundPlayback_暂不支持","func":function func(e){N.n.consoleTest("videoContext_exitBackgroundPlayback"),c.exitBackgroundPlayback(),N.n.consoleNormal("exitBackgroundPlayback")}},{"id":"video_exitFullScreen","func":function func(e){N.n.consoleTest("videoContext_exitFullScreen"),c.exitFullScreen(),N.n.consoleNormal("exitFullScreen")}},{"id":"video_exitPictureInPicture_暂不支持","func":function func(n){N.n.consoleTest("videoContext_exitPictureInPicture"),c.exitPictureInPicture({"success":function success(o){N.n.consoleSuccess.call((0,i.Z)(e),o,n)},"fail":function fail(o){N.n.consoleFail.call((0,i.Z)(e),o,n)},"complete":function complete(o){N.n.consoleComplete.call((0,i.Z)(e),o,n)}}).then((function(o){N.n.consoleResult.call((0,i.Z)(e),o,n)}))}},{"id":"video_hideStatusBar_暂不支持","func":function func(e){N.n.consoleTest("videoContext_hideStatusBar"),c.hideStatusBar(),N.n.consoleNormal("hideStatusBar")}},{"id":"video_pause","func":function func(e){N.n.consoleTest("videoContext_pause"),c.pause(),N.n.consoleNormal("pause")}},{"id":"video_play","func":function func(e){N.n.consoleTest("videoContext_play"),c.play(),N.n.consoleNormal("play")}},{"id":"video_playbackRate_暂不支持","func":function func(e){N.n.consoleTest("videoContext_playbackRate"),c.playbackRate(1.5),N.n.consoleNormal("playbackRate")}},{"id":"video_requestBackgroundPlayback_暂不支持","func":function func(e){N.n.consoleTest("videoContext_requestBackgroundPlayback"),c.requestBackgroundPlayback(),N.n.consoleNormal("requestBackgroundPlayback")}},{"id":"video_requestFullScreen","inputData":{"direction":0},"func":function func(e,n){N.n.consoleTest("videoContext_requestFullScreen"),c.requestFullScreen((0,t.Z)({},n)),setTimeout((function(){c.exitFullScreen(),N.n.consoleNormal("exitFullScreen")}),8e3),N.n.consoleNormal("requestFullScreen")}},{"id":"video_seek","func":function func(e){N.n.consoleTest("videoContext_seek"),c.seek(5),N.n.consoleNormal("seek")}},{"id":"video_sendDanmu_暂不支持","func":function func(e){N.n.consoleTest("videoContext_sendDanmu"),c.sendDanmu({"text":"测试弹幕","color":"#FFF"}),N.n.consoleNormal("sendDanmu")}},{"id":"video_showStatusBar_暂不支持","func":function func(e){N.n.consoleTest("videoContext_showStatusBar"),c.showStatusBar(),N.n.consoleNormal("showStatusBar")}},{"id":"video_stop","func":function func(e){N.n.consoleTest("videoContext_stop"),c.stop(),N.n.consoleNormal("stop")}}]}),e}return(0,s.Z)(Index,[{"key":"render","value":function render(){var e=this.state.list;return(0,k.jsxs)(y.View,{"className":"api-page","children":[(0,k.jsx)(b.Z,{"buttonList":e}),(0,k.jsx)(y.Video,{"id":"myVideo","src":"https://storage.360buyimg.com/jdrd-blog/27.mp3"})]})}}]),Index}(d.Component)},"1834":function(e,n,o){var c=o(21065),t=Symbol.for("react.element"),a=Symbol.for("react.fragment"),s=Object.prototype.hasOwnProperty,i=c.__SECRET_INTERNALS_DO_NOT_USE_OR_YOU_WILL_BE_FIRED.ReactCurrentOwner,l={"key":!0,"ref":!0,"__self":!0,"__source":!0};function q(e,n,o){var c,a={},u=null,r=null;for(c in void 0!==o&&(u=""+o),void 0!==n.key&&(u=""+n.key),void 0!==n.ref&&(r=n.ref),n)s.call(n,c)&&!l.hasOwnProperty(c)&&(a[c]=n[c]);if(e&&e.defaultProps)for(c in n=e.defaultProps)void 0===a[c]&&(a[c]=n[c]);return{"$$typeof":t,"type":e,"key":u,"ref":r,"props":a,"_owner":i.current}}n.Fragment=a,n.jsx=q,n.jsxs=q},"66658":function(e,n,o){e.exports=o(1834)}}]);