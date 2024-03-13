/*! For license information please see 2786.js.LICENSE.txt */
"use strict";(self.webpackJsonp=self.webpackJsonp||[]).push([[2786],{"32541":function(e,r,s){s.d(r,{"Z":function(){return d}});var t=s(3799),n=s(32461),a=s(53202),o=s(28673),i=s(66306),l=s(98612),c=s(955),p=s(65169),d=function(e){(0,a.Z)(ComponentState,e);var r=(0,o.Z)(ComponentState);function ComponentState(){return(0,t.Z)(this,ComponentState),r.apply(this,arguments)}return(0,n.Z)(ComponentState,[{"key":"render","value":function render(){return(0,p.jsxs)(c.View,{"className":"page-state","children":[(0,p.jsxs)(c.View,{"className":"page-state-platform","children":["组件类型：",this.props.platform]}),(0,p.jsxs)(c.View,{"className":"page-state-rate","children":["适配进度：",this.props.rate,"%"]})]})}}]),ComponentState}(l.Component);(0,i.Z)(d,"options",{"addGlobalClass":!0})},"6575":function(e,r,s){s.d(r,{"Z":function(){return d}});var t=s(3799),n=s(32461),a=s(53202),o=s(28673),i=s(66306),l=s(98612),c=s(955),p=s(65169),d=function(e){(0,a.Z)(Header,e);var r=(0,o.Z)(Header);function Header(){return(0,t.Z)(this,Header),r.apply(this,arguments)}return(0,n.Z)(Header,[{"key":"render","value":function render(){return(0,p.jsxs)(c.View,{"className":"page-head","children":[(0,p.jsx)(c.View,{"className":"page-head-title","children":this.props.title}),(0,p.jsx)(c.View,{"className":"page-head-line"}),this.props.desc?(0,p.jsx)(c.View,{"className":"page-head-desc","children":this.props.desc}):null]})}}]),Header}(l.Component);(0,i.Z)(d,"options",{"addGlobalClass":!0})},"2786":function(e,r,s){s.r(r),s.d(r,{"default":function(){return u}});var t=s(3799),n=s(32461),a=s(16556),o=s(53202),i=s(28673),l=s(66306),c=s(98612),p=s(955),d=s(6575),m=s(32541),h=s(65169),u=function(e){(0,o.Z)(PageView,e);var r=(0,i.Z)(PageView);function PageView(){var e;return(0,t.Z)(this,PageView),e=r.apply(this,arguments),(0,l.Z)((0,a.Z)(e),"state",{"progress":0}),(0,l.Z)((0,a.Z)(e),"handleStart",(function(){e._timmer||e.state.progress>100||(e._timmer=setInterval((function(){var r=e.state.progress+2;if(r>100)return e.handleStop();e.setState({"progress":r})}),100))})),(0,l.Z)((0,a.Z)(e),"handleStop",(function(){e._timmer&&(clearInterval(e._timmer),e._timmer=null)})),(0,l.Z)((0,a.Z)(e),"handleReset",(function(){e.handleStop(),e.setState({"progress":0})})),e._timmer=null,e}return(0,n.Z)(PageView,[{"key":"render","value":function render(){var e=this.state.progress;return(0,h.jsxs)(p.View,{"className":"components-page","children":[(0,h.jsxs)(p.View,{"className":"components-page__header","children":[(0,h.jsx)(d.Z,{"title":"Progress"}),(0,h.jsx)(m.Z,{"platform":"H5","rate":"100","children":" "})]}),(0,h.jsxs)(p.View,{"className":"components-page__body","children":[(0,h.jsxs)(p.View,{"className":"components-page__body-example example","children":[(0,h.jsx)(p.View,{"className":"example-progress","children":(0,h.jsx)(p.Progress,{"percent":20,"showInfo":!0,"strokeWidth":2})}),(0,h.jsx)(p.View,{"className":"example-progress","children":(0,h.jsx)(p.Progress,{"percent":40,"strokeWidth":2,"active":!0})}),(0,h.jsx)(p.View,{"className":"example-progress","children":(0,h.jsx)(p.Progress,{"percent":60,"strokeWidth":2,"active":!0})}),(0,h.jsx)(p.View,{"className":"example-progress","children":(0,h.jsx)(p.Progress,{"percent":80,"strokeWidth":2,"active":!0,"activeColor":"blue"})})]}),(0,h.jsxs)(p.View,{"className":"components-page__body-example example","children":[(0,h.jsx)(p.View,{"className":"example-progress","children":(0,h.jsx)(p.Progress,{"showInfo":!0,"strokeWidth":2,"percent":e,"activeColor":"#3C7FE8"})}),(0,h.jsxs)(p.View,{"children":[(0,h.jsx)(p.Button,{"onClick":this.handleStart,"children":"加载"}),(0,h.jsx)(p.Button,{"onClick":this.handleStop,"children":"暂停"}),(0,h.jsx)(p.Button,{"onClick":this.handleReset,"children":"重置"})]})]})]})]})}}]),PageView}(c.Component)},"55001":function(e,r,s){var t=s(98612),n=Symbol.for("react.element"),a=Symbol.for("react.fragment"),o=Object.prototype.hasOwnProperty,i=t.__SECRET_INTERNALS_DO_NOT_USE_OR_YOU_WILL_BE_FIRED.ReactCurrentOwner,l={"key":!0,"ref":!0,"__self":!0,"__source":!0};function q(e,r,s){var t,a={},c=null,p=null;for(t in void 0!==s&&(c=""+s),void 0!==r.key&&(c=""+r.key),void 0!==r.ref&&(p=r.ref),r)o.call(r,t)&&!l.hasOwnProperty(t)&&(a[t]=r[t]);if(e&&e.defaultProps)for(t in r=e.defaultProps)void 0===a[t]&&(a[t]=r[t]);return{"$$typeof":n,"type":e,"key":c,"ref":p,"props":a,"_owner":i.current}}r.Fragment=a,r.jsx=q,r.jsxs=q},"65169":function(e,r,s){e.exports=s(55001)}}]);