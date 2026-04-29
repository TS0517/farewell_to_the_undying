# 戦闘縦切りプロトタイプ アート仕様

## 目的

ポーズ差し替え式2Dスプライトで、商用品質に近づける制作フローが成立するか確認するための仮仕様です。
本番素材は同じファイル構造、または `battle_sprite_manifest.json` のパス差し替えで置き換えます。

## 保存場所

Godotプロジェクト基準:

- 背景: `godot_project/assets/prototypes/battle/backgrounds/`
- 主人公: `godot_project/assets/prototypes/battle/characters/hero_prince/`
- 魔物: `godot_project/assets/prototypes/battle/monsters/forest_beast/`
- 画像パス定義: `godot_project/data/prototypes/battle_sprite_manifest.json`

## 必要ポーズ

各キャラクター/魔物ごとに、以下5状態のPNGを用意します。

- `idle`: 通常待機
- `attack`: 通常攻撃
- `hit`: 被弾
- `skill`: スキル発動
- `death`: 死亡

## 命名規則

主人公:

- `hero_prince_idle.png`
- `hero_prince_attack.png`
- `hero_prince_hit.png`
- `hero_prince_skill.png`
- `hero_prince_death.png`

魔物:

- `forest_beast_idle.png`
- `forest_beast_attack.png`
- `forest_beast_hit.png`
- `forest_beast_skill.png`
- `forest_beast_death.png`

背景:

- `test_forest_ruins.png`

## 推奨画像サイズ

- 背景: 1920x1080px
- 人型キャラ全身: 512x768px
- 大型魔物: 768x768px
- 透過PNG推奨
- 余白込みで全ポーズのキャンバスサイズを統一
- 足元位置が全ポーズでずれないようにする

## 制作メモ

- Godot側では1枚のPNGを状態ごとに差し替えます。
- 攻撃時の前進、被弾時の揺れ/赤点滅、スキル時の発光/拡大、死亡時の縮小フェードはコード側で付けます。
- ポーズ絵には強いモーションブラーを入れすぎず、ゲーム内演出と重ねても読める形にします。
- 本番画像へ差し替える場合は、既存PNGを置き換えるか、`battle_sprite_manifest.json` の各パスを変更します。
