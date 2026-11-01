Write-Host "===================================================" -ForegroundColor Cyan
Write-Host "[Redmine 7.0] プラグインのマイグレーションを開始します..." -ForegroundColor Cyan
Write-Host "===================================================" -ForegroundColor Cyan

# 1. コンテナ内でマイグレーションコマンドを実行
docker compose exec redmine bash -lc 'export SECRET_KEY_BASE=$(cat /run/secrets/secret_key_base) && bundle exec rake redmine:plugins:migrate RAILS_ENV=production'

# コマンドの成否（終了ステータス）をチェック
if ($LASTEXITCODE -ne 0) {
    Write-Host "`n[ERROR] マイグレーション中にエラーが発生しました。" -ForegroundColor Red
    Write-Host "プラグインがRedmine 7.0 (Rails 8) に対応していない可能性があります。" -ForegroundColor Red
    Read-Host "`nEnterキーを押して終了してください..."
    exit $LASTEXITCODE
}

Write-Host "`n===================================================" -ForegroundColor Green
Write-Host "[SUCCESS] マイグレーション成功。Redmineを再起動します..." -ForegroundColor Green
Write-Host "===================================================" -ForegroundColor Green

# 2. 設定を反映させるためにRedmineコンテナを再起動
docker compose restart redmine

Write-Host "`n===================================================" -ForegroundColor Cyan
Write-Host "[DONE] すべての処理が完了しました！ブラウザで確認してください。" -ForegroundColor Cyan
Write-Host "===================================================" -ForegroundColor Cyan

Read-Host "`nEnterキーを押して終了してください..."