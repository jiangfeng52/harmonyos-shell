/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
@Observed
export class NavigationBarData {
  public title: string = '';
  public canBackward: boolean = false;
  public titleHeight: number = 32;
  public loading: boolean = false;
  public barColor: string = '#FFFFFF'
  public barFrontColor: string = '#000000';
  public animationDuration: number = 0;
  public animationCurve: number = Curve.Linear;
  public systemBarHeight: number = 40;
  public visible: boolean = true;
  public paddingBottom: number = 8;
}

