wp post create --post_title="業務内容" --post_name="business" --post_type=page --post_status=publish
wp post create --post_title="お問い合わせ" --post_name="contact" --post_type=page --post_status=publish
wp post create --post_title="採用情報" --post_name="recruit" --post_type=page --post_status=publish
wp post create --post_title="会社概要" --post_name="company" --post_type=page --post_status=publish
 
# 会社概要（company）の下に作成
wp post create --post_title="ご挨拶" --post_name="message" --post_type=page --post_status=publish --post_parent=$(wp post list --post_type=page --field=ID --name="company")
wp post create --post_title="アクセス" --post_name="access" --post_type=page --post_status=publish --post_parent=$(wp post list --post_type=page --field=ID --name="company")
wp post create --post_title="沿革" --post_name="history" --post_type=page --post_status=publish --post_parent=$(wp post list --post_type=page --field=ID --name="company")
