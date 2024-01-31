/*! For license information please see 7049.js.LICENSE.txt */
"use strict";(self.webpackJsonp=self.webpackJsonp||[]).push([[7049],{"45177":function(e,a,t){t.d(a,{"Z":function(){return u}});var n=t(82163),r=t(6676),s=t(97150),o=t(77483),l=t(26380),i=t(21065),c=t(38036),p=t(66658),u=function(e){(0,s.Z)(ComponentState,e);var a=(0,o.Z)(ComponentState);function ComponentState(){return(0,n.Z)(this,ComponentState),a.apply(this,arguments)}return(0,r.Z)(ComponentState,[{"key":"render","value":function render(){return(0,p.jsxs)(c.View,{"className":"page-state","children":[(0,p.jsxs)(c.View,{"className":"page-state-platform","children":["组件类型：",this.props.platform]}),(0,p.jsxs)(c.View,{"className":"page-state-rate","children":["适配进度：",this.props.rate,"%"]})]})}}]),ComponentState}(i.Component);(0,l.Z)(u,"options",{"addGlobalClass":!0})},"74565":function(e,a,t){t.d(a,{"Z":function(){return u}});var n=t(82163),r=t(6676),s=t(97150),o=t(77483),l=t(26380),i=t(21065),c=t(38036),p=t(66658),u=function(e){(0,s.Z)(Header,e);var a=(0,o.Z)(Header);function Header(){return(0,n.Z)(this,Header),a.apply(this,arguments)}return(0,r.Z)(Header,[{"key":"render","value":function render(){return(0,p.jsxs)(c.View,{"className":"page-head","children":[(0,p.jsx)(c.View,{"className":"page-head-title","children":this.props.title}),(0,p.jsx)(c.View,{"className":"page-head-line"}),this.props.desc?(0,p.jsx)(c.View,{"className":"page-head-desc","children":this.props.desc}):null]})}}]),Header}(i.Component);(0,l.Z)(u,"options",{"addGlobalClass":!0})},"17049":function(e,a,t){t.r(a),t.d(a,{"default":function(){return x}});var n=t(82163),r=t(6676),s=t(65599),o=t(97150),l=t(77483),i=t(26380),c=t(21065),p=t(38036),u=t(74565),d=t(45177),h=t(66658),x=function(e){(0,o.Z)(PageTextarea,e);var a=(0,l.Z)(PageTextarea);function PageTextarea(){var e;(0,n.Z)(this,PageTextarea);for(var t=arguments.length,r=new Array(t),o=0;o<t;o++)r[o]=arguments[o];return e=a.call.apply(a,[this].concat(r)),(0,i.Z)((0,s.Z)(e),"state",{"value":"初始值"}),(0,i.Z)((0,s.Z)(e),"handleClick",(function(){e.setState({"value":"点击了按钮"})})),(0,i.Z)((0,s.Z)(e),"blur",(function(){console.log("blur")})),(0,i.Z)((0,s.Z)(e),"focus",(function(){console.log("focus")})),(0,i.Z)((0,s.Z)(e),"input",(function(a){console.log(a),e.setState({"value":a.target.value})})),e}return(0,r.Z)(PageTextarea,[{"key":"render","value":function render(){return(0,h.jsxs)(p.View,{"className":"components-page","children":[(0,h.jsxs)(p.View,{"className":"components-page__header","children":[(0,h.jsx)(u.Z,{"title":"Textarea"}),(0,h.jsx)(d.Z,{"platform":"H5","rate":"100","children":" "})]}),(0,h.jsxs)(p.View,{"className":"components-page__body","children":[(0,h.jsxs)(p.View,{"className":"components-page__body-example example","children":[(0,h.jsx)(p.View,{"className":"example-header","children":(0,h.jsx)(p.Text,{"children":"输入区域高度自适应，不会出现滚动条"})}),(0,h.jsxs)(p.View,{"className":"example-body","children":[(0,h.jsx)(p.View,{"className":"example-body__button","children":(0,h.jsx)(p.Button,{"size":"mini","type":"primary","onClick":this.handleClick,"children":"点击设置值到第一个Textarea"})}),(0,h.jsx)(p.Textarea,{"onFocus":this.focus,"onBlur":this.blur,"value":this.state.value,"placeholder":"这是一个Textarea","autoHeight":!0,"onInput":this.input})]})]}),(0,h.jsxs)(p.View,{"className":"components-page__body-example example","children":[(0,h.jsx)(p.View,{"className":"example-header","children":(0,h.jsx)(p.Text,{"children":"这是一个可以自动聚焦的textarea"})}),(0,h.jsx)(p.View,{"className":"example-body","children":(0,h.jsx)(p.Textarea,{"autoFocus":!0,"placeholder":"这是一个Textarea"})})]})]})]})}}]),PageTextarea}(c.Component)},"1834":function(e,a,t){var n=t(21065),r=Symbol.for("react.element"),s=Symbol.for("react.fragment"),o=Object.prototype.hasOwnProperty,l=n.__SECRET_INTERNALS_DO_NOT_USE_OR_YOU_WILL_BE_FIRED.ReactCurrentOwner,i={"key":!0,"ref":!0,"__self":!0,"__source":!0};function q(e,a,t){var n,s={},c=null,p=null;for(n in void 0!==t&&(c=""+t),void 0!==a.key&&(c=""+a.key),void 0!==a.ref&&(p=a.ref),a)o.call(a,n)&&!i.hasOwnProperty(n)&&(s[n]=a[n]);if(e&&e.defaultProps)for(n in a=e.defaultProps)void 0===s[n]&&(s[n]=a[n]);return{"$$typeof":r,"type":e,"key":c,"ref":p,"props":s,"_owner":l.current}}a.Fragment=s,a.jsx=q,a.jsxs=q},"66658":function(e,a,t){e.exports=t(1834)}}]);