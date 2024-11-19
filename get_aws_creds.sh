yubi_totp=$(ykman oath accounts code Codethink -s)

saml2aws login --session-duration 43200 --mfa-token "$yubi_totp"

export AWS_PROFILE=ct-saml
