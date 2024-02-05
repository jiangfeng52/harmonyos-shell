import {webview } from '@kit.ArkWeb'

export interface RouteNode {
  url: string;
  controller: webview.WebviewController
}