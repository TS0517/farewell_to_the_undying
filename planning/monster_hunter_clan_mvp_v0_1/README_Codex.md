# 魔物狩りの一族 MVP v0.1 - Codex開発用README

## 目的
Godotで、スマホ横画面向けの10年版MVPを作る。
まず検証したい体験は「酒場で仲間と出会う → 戦う → 成長する → 老いる → 戦死/引退/病死する → 王子や王国に残る」。

## 開発前提
- Engine: Godot
- Language: GDScript
- Main target: Android / iOS smartphone, landscape orientation
- Development flow: PCで高速テストし、節目でAndroid実機テスト
- Future target: Steam。Switchは後回し
- MVP duration: 10 years
- 1 year = Spring kingdom phase / Summer battle / Autumn kingdom phase / Winter battle
- 10 years = 20 battles

## 最初に作るもの
1. データ読み込み基盤
2. 多言語テキストID管理
3. 酒場画面
4. 仲間雇用
5. 見下ろし3x3 ATB戦闘
6. 年齢成長/全盛期/衰退
7. 戦死/クリスタル/引退/病死
8. 戦闘リザルト会話、王国つぶやき、手紙

## 重要な思想
- 画面や文言は仮でよい。まずプレイ可能な骨格を優先する。
- テキストはコード直書きしない。必ずlocalization ID経由にする。
- キャラ/職業/スキル/会話/プロフィールはJSONなどのデータ駆動にする。
- UIはスマホ横画面を前提に、タップしやすいサイズにする。

## 参照ファイル
- docs/spec_mvp_v0_1.md: MVP仕様書
- docs/codex_implementation_prompt.md: Codexに渡す実装指示
- docs/data_schema.md: データ構造案
- docs/roadmap.md: 開発順序
- data_sample/: JSONサンプル
