/*! For license information please see 3285.js.LICENSE.txt */
"use strict";(self.webpackJsonp=self.webpackJsonp||[]).push([[3285],{"63682":function(n,e,a){a.d(e,{"Z":function(){return k}});var o=a(82163),t=a(6676),c=a(65599),i=a(97150),r=a(77483),u=a(26380),s=a(21065),l=a(35859),d=a(38036),f=a(91753),p=a(66658),g=function(n){(0,i.Z)(Index,n);var e=(0,r.Z)(Index);function Index(){var n;(0,o.Z)(this,Index);for(var a=arguments.length,t=new Array(a),i=0;i<a;i++)t[i]=arguments[i];return n=e.call.apply(e,[this].concat(t)),(0,u.Z)((0,c.Z)(n),"state",{}),(0,u.Z)((0,c.Z)(n),"stringify",(function(n){var e=new Map,a=JSON.stringify(n,(function(n,a){if(void 0===a)return"undefined";if("function"==typeof a)return"function";if("object"===(0,f.Z)(a)&&null!==a){if(e.has(a))return;e.set(a,a)}return a}));return e.clear(),a})),n}return(0,t.Z)(Index,[{"key":"render","value":function render(){var n=this.props,e=n.testApi,a=n.callbackRes;return(0,p.jsx)(d.View,{"className":"callback-content","children":(0,p.jsx)(d.View,{"className":"callback-res","id":"".concat(e,"-callback"),"children":this.stringify(a)})})}}]),Index}(s.Component),k=function(n){(0,i.Z)(Index,n);var e=(0,r.Z)(Index);function Index(){var n;(0,o.Z)(this,Index);for(var a=arguments.length,t=new Array(a),i=0;i<a;i++)t[i]=arguments[i];return n=e.call.apply(e,[this].concat(t)),(0,u.Z)((0,c.Z)(n),"state",{"inputData":[],"textareaControl":[],"hiddenNum":0}),(0,u.Z)((0,c.Z)(n),"changeData",(function(e,a){var o=n.state.inputData;try{o[a]=JSON.parse(e.detail.value)}catch(n){o[a]=e.detail.value}n.setState({"inputData":o})})),(0,u.Z)((0,c.Z)(n),"submitData",(function(n,e,a){null!=e.func&&("string"==typeof n?(0,l.CF)({"icon":"error","title":"请检查参数格式"}):null==n?e.func(a):e.func(a,n))})),(0,u.Z)((0,c.Z)(n),"minusHidden",(function(){var e=n.state.hiddenNum;e>0?n.setState({"hiddenNum":e-1}):(0,l.CF)({"title":"已全部显示"})})),(0,u.Z)((0,c.Z)(n),"addHidden",(function(){var e=n.state.hiddenNum;e<n.props.buttonList.length?n.setState({"hiddenNum":e+1}):(0,l.CF)({"title":"已全部隐藏"})})),(0,u.Z)((0,c.Z)(n),"hideTextarea",(function(e){var a=n.state.textareaControl;a[e]=!a[e],n.setState({"textareaControl":a})})),(0,u.Z)((0,c.Z)(n),"isAdvancedAPI",(function(n){try{return asAPIMap.get(n)}catch(n){return!1}})),n}return(0,t.Z)(Index,[{"key":"componentDidMount","value":function componentDidMount(){var n=this.props.buttonList,e=[],a=[];n.forEach((function(n){n.inputData?e.push(n.inputData):e.push(void 0),a.push(!0)})),this.setState({"inputData":e})}},{"key":"render","value":function render(){var n=this,e=this.props.buttonList,a=this.state,o=a.inputData,t=a.textareaControl,c=a.hiddenNum;return(0,p.jsxs)(d.View,{"className":"button-list","children":[(0,p.jsxs)(d.View,{"className":"hidden-control","children":[(0,p.jsx)(d.Text,{"children":"隐藏按钮"}),(0,p.jsxs)(d.View,{"className":"stepper","children":[(0,p.jsx)(d.View,{"className":"normal","onClick":this.minusHidden,"children":"-"}),(0,p.jsx)(d.View,{"className":"stepper-num","children":c}),(0,p.jsx)(d.View,{"className":"normal","onClick":this.addHidden,"children":"+"})]})]}),e.map((function(e,a){return(0,p.jsxs)(d.View,{"className":"api-page-btn-area ".concat(a<c?"api-page-btn-area-hidden":""),"children":[null!=o[a]?(0,p.jsxs)(d.View,{"className":"api-textarea-area","children":[(0,p.jsx)(d.Textarea,{"className":"api-input-area ".concat(t[a]?"api-input-area-hidden":""),"maxlength":-1,"id":"".concat(e.id,"-input"),"value":"string"==typeof o[a]?o[a]:JSON.stringify(o[a],null,2),"onInput":function onInput(e){n.changeData(e,a)}}),(0,p.jsx)(d.View,{"className":"textarea-control","onClick":function onClick(){n.hideTextarea(a)},"children":t[a]?"+":"-"})]}):"",(0,p.jsxs)(d.View,{"className":"api-page-btn ".concat(null==e.func?"api-page-btn-uncreate":""," ").concat(n.isAdvancedAPI(e.id)?"api-page-btn-advanced":""),"id":e.id,"onClick":function onClick(){n.submitData(o[a],e,a)},"children":[e.id,null!=e.callbackRes?(0,p.jsx)(g,{"testApi":e.id,"callbackRes":e.callbackRes}):""]})]},e.id)}))]})}}]),Index}(s.Component)},"43285":function(n,e,a){a.r(e),a.d(e,{"default":function(){return m}});var o,t=a(82163),c=a(6676),i=a(65599),r=a(97150),u=a(77483),s=a(26380),l=a(21065),d=a(61791),f=a(38036),p=a(63682),g=a(49141),k=a(66658),m=function(n){(0,r.Z)(Index,n);var e=(0,u.Z)(Index);function Index(){var n;(0,t.Z)(this,Index);for(var a=arguments.length,c=new Array(a),r=0;r<a;r++)c[r]=arguments[r];return n=e.call.apply(e,[this].concat(c)),(0,s.Z)((0,i.Z)(n),"state",{"list":[{"id":"getBackgroundAudioManager","func":function func(n){g.n.consoleTest("getBackgroundAudioManager"),(o=(0,d.uR)()).src="https://storage.360buyimg.com/jdrd-blog/27.mp3",o.title="此时此刻",o.epname="此时此刻",o.singer="许巍",o.coverImgUrl="https://y.gtimg.cn/music/photo_new/T002R300x300M000003rsKF44GyaSk.jpg?max_age=2592000",o.webUrl="https://y.gtimg.cn/music/photo_new/T002R300x300M000003rsKF44GyaSk.jpg?max_age=2592000",o.protocol="http",o.referrerPolicy="origin",g.n.consoleNormal("get backgroundAudioManager :",o)}},{"id":"play","func":function func(n){g.n.consoleTest("BackgroundAudioManager_play"),o.play()}},{"id":"pause","func":function func(n){g.n.consoleTest("BackgroundAudioManager_pause"),o.pause()}},{"id":"stop","func":function func(n){g.n.consoleTest("BackgroundAudioManager_stop"),o.stop()}},{"id":"seek","func":function func(n){g.n.consoleTest("BackgroundAudioManager_seek"),o.seek(150)}},{"id":"onCanplay","func":function func(n){g.n.consoleTest("BackgroundAudioManager_onCanplay"),o.onCanplay((function(){g.n.consoleNormal("onCanplay callback")}))}},{"id":"onWaiting","func":function func(n){g.n.consoleTest("BackgroundAudioManager_onWaiting"),o.onPlay((function(){g.n.consoleNormal("onWaiting callback")}))}},{"id":"onError","func":function func(n){g.n.consoleTest("backgroundAudioManagert_onError"),o.onError((function(){g.n.consoleNormal("onError callback")}))}},{"id":"onPlay","func":function func(n){g.n.consoleTest("BackgroundAudioManager_onPlay"),o.onPlay((function(){g.n.consoleNormal("onPlay callback")}))}},{"id":"onPause","func":function func(n){g.n.consoleTest("BackgroundAudioManager_onPause"),o.onPause((function(){g.n.consoleNormal("onPause callback")}))}},{"id":"onSeeking","func":function func(n){g.n.consoleTest("BackgroundAudioManager_onSeeking"),o.onSeeking((function(){g.n.consoleNormal("onSeeking callback")}))}},{"id":"onSeeked","func":function func(n){g.n.consoleTest("BackgroundAudioManager_onSeeked"),o.onSeeked((function(){g.n.consoleNormal("onSeeked callback")}))}},{"id":"onEnded","func":function func(n){g.n.consoleTest("BackgroundAudioManager_onEnded"),o.onEnded((function(){g.n.consoleNormal("onEnded callback")}))}},{"id":"BackgroundAudioManager_onStop","func":function func(n){g.n.consoleTest("BackgroundAudioManager_onStop"),o.onStop((function(){g.n.consoleNormal("onStop callback")}))}},{"id":"onTimeUpdate","func":function func(n){g.n.consoleTest("BackgroundAudioManager_onTimeUpdate"),o.onTimeUpdate((function(){g.n.consoleNormal("onTimeUpdate callback")}))}},{"id":"onPrev_暂不支持","func":function func(n){g.n.consoleTest("BackgroundAudioManager_onPrev"),o.onPrev((function(){g.n.consoleNormal("onPrev callback")}))}},{"id":"onNext_暂不支持","func":function func(n){g.n.consoleTest("BackgroundAudioManager_onNext"),o.onNext((function(){g.n.consoleNormal("onNext callback")}))}}]}),n}return(0,c.Z)(Index,[{"key":"render","value":function render(){var n=this.state.list;return(0,k.jsx)(f.View,{"className":"api-page","children":(0,k.jsx)(p.Z,{"buttonList":n})})}}]),Index}(l.Component)},"1834":function(n,e,a){var o=a(21065),t=Symbol.for("react.element"),c=Symbol.for("react.fragment"),i=Object.prototype.hasOwnProperty,r=o.__SECRET_INTERNALS_DO_NOT_USE_OR_YOU_WILL_BE_FIRED.ReactCurrentOwner,u={"key":!0,"ref":!0,"__self":!0,"__source":!0};function q(n,e,a){var o,c={},s=null,l=null;for(o in void 0!==a&&(s=""+a),void 0!==e.key&&(s=""+e.key),void 0!==e.ref&&(l=e.ref),e)i.call(e,o)&&!u.hasOwnProperty(o)&&(c[o]=e[o]);if(n&&n.defaultProps)for(o in e=n.defaultProps)void 0===c[o]&&(c[o]=e[o]);return{"$$typeof":t,"type":n,"key":s,"ref":l,"props":c,"_owner":r.current}}e.Fragment=c,e.jsx=q,e.jsxs=q},"66658":function(n,e,a){n.exports=a(1834)}}]);