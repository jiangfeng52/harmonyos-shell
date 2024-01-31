/*! For license information please see 8385.js.LICENSE.txt */
"use strict";(self.webpackJsonp=self.webpackJsonp||[]).push([[8385],{"45177":function(e,t,s){s.d(t,{"Z":function(){return h}});var i=s(82163),a=s(6676),r=s(97150),l=s(77483),c=s(26380),n=s(21065),o=s(38036),d=s(66658),h=function(e){(0,r.Z)(ComponentState,e);var t=(0,l.Z)(ComponentState);function ComponentState(){return(0,i.Z)(this,ComponentState),t.apply(this,arguments)}return(0,a.Z)(ComponentState,[{"key":"render","value":function render(){return(0,d.jsxs)(o.View,{"className":"page-state","children":[(0,d.jsxs)(o.View,{"className":"page-state-platform","children":["组件类型：",this.props.platform]}),(0,d.jsxs)(o.View,{"className":"page-state-rate","children":["适配进度：",this.props.rate,"%"]})]})}}]),ComponentState}(n.Component);(0,c.Z)(h,"options",{"addGlobalClass":!0})},"74565":function(e,t,s){s.d(t,{"Z":function(){return h}});var i=s(82163),a=s(6676),r=s(97150),l=s(77483),c=s(26380),n=s(21065),o=s(38036),d=s(66658),h=function(e){(0,r.Z)(Header,e);var t=(0,l.Z)(Header);function Header(){return(0,i.Z)(this,Header),t.apply(this,arguments)}return(0,a.Z)(Header,[{"key":"render","value":function render(){return(0,d.jsxs)(o.View,{"className":"page-head","children":[(0,d.jsx)(o.View,{"className":"page-head-title","children":this.props.title}),(0,d.jsx)(o.View,{"className":"page-head-line"}),this.props.desc?(0,d.jsx)(o.View,{"className":"page-head-desc","children":this.props.desc}):null]})}}]),Header}(n.Component);(0,c.Z)(h,"options",{"addGlobalClass":!0})},"88385":function(e,t,s){s.r(t),s.d(t,{"default":function(){return p}});var i=s(82163),a=s(6676),r=s(65599),l=s(97150),c=s(77483),n=s(26380),o=s(21065),d=s(38036),h=s(74565),m=s(45177),u=s(66658),p=function(e){(0,l.Z)(PageView,e);var t=(0,c.Z)(PageView);function PageView(){var e;return(0,i.Z)(this,PageView),e=t.apply(this,arguments),(0,n.Z)((0,r.Z)(e),"setAutoPlay",(function(t){e.setState({"isAutoplay":t.detail.value})})),(0,n.Z)((0,r.Z)(e),"setVerticalAutoPlay",(function(t){e.setState({"verticalIsAutoplay":t.detail.value})})),(0,n.Z)((0,r.Z)(e),"setCircular",(function(t){e.setState({"isCircular":t.detail.value})})),(0,n.Z)((0,r.Z)(e),"setVerticalCircular",(function(t){e.setState({"verticalIsCircular":t.detail.value})})),(0,n.Z)((0,r.Z)(e),"setIndicatorDots",(function(t){e.setState({"hasIndicatorDots":t.detail.value})})),(0,n.Z)((0,r.Z)(e),"setVerticalIndicatorDots",(function(t){e.setState({"verticalHasIndicatorDots":t.detail.value})})),(0,n.Z)((0,r.Z)(e),"setInterval",(function(t){e.setState({"interval":t.detail.value})})),(0,n.Z)((0,r.Z)(e),"setDuration",(function(t){console.log((0,r.Z)(e)),e.setState({"duration":t.detail.value})})),e.state={"current":1,"duration":500,"interval":5e3,"isCircular":!0,"verticalIsCircular":!0,"isAutoplay":!1,"verticalIsAutoplay":!1,"hasIndicatorDots":!0,"verticalHasIndicatorDots":!0},e}return(0,a.Z)(PageView,[{"key":"render","value":function render(){var e=this.state,t=e.current,s=e.isAutoplay,i=e.duration,a=e.isCircular,r=e.interval,l=e.hasIndicatorDots,c=e.verticalIsCircular,n=e.verticalHasIndicatorDots,o=e.verticalIsAutoplay;return(0,u.jsxs)(d.View,{"className":"components-page","children":[(0,u.jsxs)(d.View,{"className":"components-page__header","children":[(0,u.jsx)(h.Z,{"title":"Swiper"}),(0,u.jsx)(m.Z,{"platform":"H5","rate":"100","children":" "})]}),(0,u.jsxs)(d.View,{"className":"components-page__body swiper","children":[(0,u.jsxs)(d.View,{"className":"components-page__body-example example","children":[(0,u.jsx)(d.View,{"className":"example-header","children":(0,u.jsx)(d.Text,{"children":"Swiper 横向滑动"})}),(0,u.jsxs)(d.View,{"className":"example-body","children":[(0,u.jsxs)(d.Swiper,{"slideMult":"10","indicatorColor":"#999","indicatorActiveColor":"#333","current":t,"duration":i,"interval":r,"circular":a,"autoplay":s,"indicatorDots":l,"preMargin":"20","children":[(0,u.jsx)(d.SwiperItem,{"children":(0,u.jsx)(d.View,{"className":"demo-text-1"})}),(0,u.jsx)(d.SwiperItem,{"children":(0,u.jsx)(d.View,{"className":"demo-text-2"})}),(0,u.jsx)(d.SwiperItem,{"children":(0,u.jsx)(d.View,{"className":"demo-text-3"})})]}),(0,u.jsxs)(d.View,{"className":"switch-list","children":[(0,u.jsxs)(d.View,{"className":"switch-list__item","children":[(0,u.jsx)(d.View,{"className":"switch-list__text","children":"指示点"}),(0,u.jsx)(d.Switch,{"checked":l,"onChange":this.setIndicatorDots})]}),(0,u.jsxs)(d.View,{"className":"switch-list__item","children":[(0,u.jsx)(d.View,{"className":"switch-list__text","children":"自动播放"}),(0,u.jsx)(d.Switch,{"checked":s,"onChange":this.setAutoPlay})]}),(0,u.jsxs)(d.View,{"className":"switch-list__item","children":[(0,u.jsx)(d.View,{"className":"switch-list__text","children":"循环播放"}),(0,u.jsx)(d.Switch,{"checked":a,"onChange":this.setCircular})]})]}),(0,u.jsxs)(d.View,{"className":"slider-list","children":[(0,u.jsxs)(d.View,{"className":"slider-list__item","children":[(0,u.jsx)(d.View,{"className":"slider-list__item-header","children":(0,u.jsx)(d.Text,{"children":"幻灯片切换时长(ms)"})}),(0,u.jsx)(d.View,{"className":"slider-list__item-body","children":(0,u.jsx)(d.Slider,{"showValue":!0,"step":1,"min":500,"max":2e3,"value":i,"onChange":this.setDuration})})]}),(0,u.jsxs)(d.View,{"className":"slider-list__item","children":[(0,u.jsx)(d.View,{"className":"slider-list__item-header","children":(0,u.jsx)(d.Text,{"children":"自动播放间隔时长(ms)"})}),(0,u.jsx)(d.View,{"className":"slider-list__item-body","children":(0,u.jsx)(d.Slider,{"showValue":!0,"step":1,"min":2e3,"max":1e4,"value":this.state.interval,"onChange":this.setInterval})})]})]})]})]}),(0,u.jsxs)(d.View,{"className":"components-page__body-example example","children":[(0,u.jsx)(d.View,{"className":"example-header","children":(0,u.jsx)(d.Text,{"children":"Swiper 纵向滑动"})}),(0,u.jsx)(d.View,{"className":"example-body","children":(0,u.jsxs)(d.Swiper,{"slideMult":"10","className":"test-h","indicatorColor":"#999","indicatorActiveColor":"#333","vertical":!0,"circular":c,"indicatorDots":n,"autoplay":o,"preMargin":"20","children":[(0,u.jsx)(d.SwiperItem,{"children":(0,u.jsx)(d.View,{"className":"demo-text-1"})}),(0,u.jsx)(d.SwiperItem,{"children":(0,u.jsx)(d.View,{"className":"demo-text-2"})}),(0,u.jsx)(d.SwiperItem,{"children":(0,u.jsx)(d.View,{"className":"demo-text-3"})})]})}),(0,u.jsxs)(d.View,{"className":"switch-list","children":[(0,u.jsxs)(d.View,{"className":"switch-list__item","children":[(0,u.jsx)(d.View,{"className":"switch-list__text","children":"指示点"}),(0,u.jsx)(d.Switch,{"checked":n,"onChange":this.setVerticalIndicatorDots})]}),(0,u.jsxs)(d.View,{"className":"switch-list__item","children":[(0,u.jsx)(d.View,{"className":"switch-list__text","children":"自动播放"}),(0,u.jsx)(d.Switch,{"checked":o,"onChange":this.setVerticalAutoPlay})]}),(0,u.jsxs)(d.View,{"className":"switch-list__item","children":[(0,u.jsx)(d.View,{"className":"switch-list__text","children":"循环播放"}),(0,u.jsx)(d.Switch,{"checked":c,"onChange":this.setVerticalCircular})]})]})]})]})]})}}]),PageView}(o.Component)},"1834":function(e,t,s){var i=s(21065),a=Symbol.for("react.element"),r=Symbol.for("react.fragment"),l=Object.prototype.hasOwnProperty,c=i.__SECRET_INTERNALS_DO_NOT_USE_OR_YOU_WILL_BE_FIRED.ReactCurrentOwner,n={"key":!0,"ref":!0,"__self":!0,"__source":!0};function q(e,t,s){var i,r={},o=null,d=null;for(i in void 0!==s&&(o=""+s),void 0!==t.key&&(o=""+t.key),void 0!==t.ref&&(d=t.ref),t)l.call(t,i)&&!n.hasOwnProperty(i)&&(r[i]=t[i]);if(e&&e.defaultProps)for(i in t=e.defaultProps)void 0===r[i]&&(r[i]=t[i]);return{"$$typeof":a,"type":e,"key":o,"ref":d,"props":r,"_owner":c.current}}t.Fragment=r,t.jsx=q,t.jsxs=q},"66658":function(e,t,s){e.exports=s(1834)}}]);