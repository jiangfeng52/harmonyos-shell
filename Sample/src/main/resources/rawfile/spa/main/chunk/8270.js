/*! For license information please see 8270.js.LICENSE.txt */
"use strict";(self.webpackJsonp=self.webpackJsonp||[]).push([[8270],{"32541":function(e,n,t){t.d(n,{"Z":function(){return d}});var r=t(3799),s=t(32461),a=t(53202),o=t(28673),i=t(66306),l=t(98612),c=t(955),p=t(65169),d=function(e){(0,a.Z)(ComponentState,e);var n=(0,o.Z)(ComponentState);function ComponentState(){return(0,r.Z)(this,ComponentState),n.apply(this,arguments)}return(0,s.Z)(ComponentState,[{"key":"render","value":function render(){return(0,p.jsxs)(c.View,{"className":"page-state","children":[(0,p.jsxs)(c.View,{"className":"page-state-platform","children":["组件类型：",this.props.platform]}),(0,p.jsxs)(c.View,{"className":"page-state-rate","children":["适配进度：",this.props.rate,"%"]})]})}}]),ComponentState}(l.Component);(0,i.Z)(d,"options",{"addGlobalClass":!0})},"6575":function(e,n,t){t.d(n,{"Z":function(){return d}});var r=t(3799),s=t(32461),a=t(53202),o=t(28673),i=t(66306),l=t(98612),c=t(955),p=t(65169),d=function(e){(0,a.Z)(Header,e);var n=(0,o.Z)(Header);function Header(){return(0,r.Z)(this,Header),n.apply(this,arguments)}return(0,s.Z)(Header,[{"key":"render","value":function render(){return(0,p.jsxs)(c.View,{"className":"page-head","children":[(0,p.jsx)(c.View,{"className":"page-head-title","children":this.props.title}),(0,p.jsx)(c.View,{"className":"page-head-line"}),this.props.desc?(0,p.jsx)(c.View,{"className":"page-head-desc","children":this.props.desc}):null]})}}]),Header}(l.Component);(0,i.Z)(d,"options",{"addGlobalClass":!0})},"38270":function(e,n,t){t.r(n),t.d(n,{"default":function(){return PageView}});var r=t(955),s=t(45607),a=(t(98612),t(6575)),o=t(32541),i=t(65169);function PageView(){return s.ZP.useLoad((function(){console.log("Page loaded.")})),(0,i.jsxs)(r.View,{"className":"components-page","children":[(0,i.jsxs)(r.View,{"className":"components-page__header","children":[(0,i.jsx)(a.Z,{"title":"ListView"}),(0,i.jsx)(o.Z,{"platform":"H5","rate":"100","children":" "})]}),(0,i.jsx)(r.View,{"className":"index","children":(0,i.jsxs)(r.ListView,{"padding":[10,10,10,100],"className":"listStyle","children":[(0,i.jsx)(r.View,{"children":"AAAAAAAAAAAA"}),(0,i.jsx)(r.View,{"children":"BBBBBBB"}),(0,i.jsx)(r.View,{"children":"CCCCCCCCCCCC"})]})})]})}},"55001":function(e,n,t){var r=t(98612),s=Symbol.for("react.element"),a=Symbol.for("react.fragment"),o=Object.prototype.hasOwnProperty,i=r.__SECRET_INTERNALS_DO_NOT_USE_OR_YOU_WILL_BE_FIRED.ReactCurrentOwner,l={"key":!0,"ref":!0,"__self":!0,"__source":!0};function q(e,n,t){var r,a={},c=null,p=null;for(r in void 0!==t&&(c=""+t),void 0!==n.key&&(c=""+n.key),void 0!==n.ref&&(p=n.ref),n)o.call(n,r)&&!l.hasOwnProperty(r)&&(a[r]=n[r]);if(e&&e.defaultProps)for(r in n=e.defaultProps)void 0===a[r]&&(a[r]=n[r]);return{"$$typeof":s,"type":e,"key":c,"ref":p,"props":a,"_owner":i.current}}n.Fragment=a,n.jsx=q,n.jsxs=q},"65169":function(e,n,t){e.exports=t(55001)}}]);