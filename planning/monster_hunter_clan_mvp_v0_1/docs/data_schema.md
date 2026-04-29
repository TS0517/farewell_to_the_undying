# データ構造案

## JSONとは
JSONは、ゲーム内データをテキストで管理する形式。
コード内に数値や文章を直接書かず、外部ファイルとして扱える。

例:

```json
{
  "id": "job_swordsman",
  "name_text_id": "job_swordsman_name",
  "base_stats": {"str": 12, "agi": 8, "vit": 10, "int": 4}
}
```

## 推奨ファイル構成

- jobs.json: 職業
- skills.json: スキル
- profiles.json: 人生プロフィール
- personas.json: 人格ペルソナ
- portraits.json: 顔/バストアップ画像情報
- dialogues.json: 会話
- monsters.json: 魔物
- crystals.json: クリスタル
- localization_ja.json: 日本語テキスト
- localization_en.json: 英語テキスト
- localization_zh_cn.json: 中国語簡体字テキスト

## Character生成時に持つ情報

```json
{
  "id": "ally_0001",
  "name_text_id": "name_rio",
  "age": 15,
  "prime_start": 22,
  "prime_end": 30,
  "job_id": "job_archer",
  "potential": 108,
  "persona_id": "persona_coward_kind",
  "profile_id": "profile_001",
  "portrait_id": "portrait_001",
  "stats": {"str": 7, "agi": 12, "vit": 8, "int": 6},
  "battle_count_this_year": 0,
  "kill_count_this_year": 0,
  "status": "active"
}
```

## Job

```json
{
  "id": "job_archer",
  "name_text_id": "job_archer_name",
  "front_skill_id": "skill_archer_front",
  "middle_skill_id": "skill_archer_middle",
  "back_skill_id": "skill_archer_back",
  "base_stat_weight": {"str": 0.8, "agi": 1.3, "vit": 0.8, "int": 0.7}
}
```

## Skill

```json
{
  "id": "skill_archer_back",
  "name_text_id": "skill_archer_back_name",
  "description_text_id": "skill_archer_back_desc",
  "type": "damage",
  "power": 1.3,
  "target": "enemy",
  "scaling": "agi"
}
```

## Profile

```json
{
  "id": "profile_001",
  "summary_text_id": "profile_001_summary",
  "body_text_id": "profile_001_body",
  "tags": ["young", "timid", "family", "commoner"]
}
```

## Portrait

```json
{
  "id": "portrait_001",
  "face_path": "res://assets/portraits/face_001.png",
  "bust_path": "res://assets/portraits/bust_001.png",
  "tags": ["young", "timid", "commoner", "archer_like"]
}
```

## Persona

```json
{
  "id": "persona_coward_kind",
  "name_text_id": "persona_coward_kind_name",
  "tags": ["timid", "kind", "family"],
  "first_person": "僕",
  "speech_note": "不安げだが仲間を気遣う。弱音は吐くが逃げ切らない。"
}
```

## Dialogue

```json
{
  "id": "dlg_coward_win_hard_001",
  "trigger": "battle_win_hard",
  "persona_id": "persona_coward_kind",
  "age_stage": "any",
  "meaning": "relief_survived",
  "priority": 30,
  "text_id": "dlg_coward_win_hard_001"
}
```

## Localization

```json
{
  "job_archer_name": "弓兵",
  "skill_archer_back_name": "狙撃",
  "dlg_coward_win_hard_001": "……足がまだ震えてます。でも、みんながいたから戻れました。"
}
```
