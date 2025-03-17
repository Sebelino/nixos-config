#!/usr/bin/env bash

set -Eeuo pipefail

full_pdf='neurotecheu_application_grant.pdf'
to_be_signed_page_number=3
header_indices='1-2'
sig_png='signature.png'
scale='0.091'
offset='0cm -6cm'
final_pdf="final.pdf"

tmp_path='/tmp/sign_sh'
sig_pdf="$tmp_path/signature.pdf"
sig_pdf2="$tmp_path/signature2.pdf"
to_be_signed_page="$tmp_path/to_be_signed.pdf"
signed_page="$tmp_path/signed_page.pdf"
header_pdf="$tmp_path/header.pdf"

set -x

rm -rf "$tmp_path"
mkdir -p "$tmp_path"

# Convert signature PNG to PDF
convert "$sig_png" "$sig_pdf"

# Offset signature
pdfjam --paper 'a4paper' --scale "$scale" --offset "$offset" "$sig_pdf" --outfile "$sig_pdf2"

# Extract page to be signed
pdftk "$full_pdf" cat "$to_be_signed_page_number" output "$to_be_signed_page"

# Stamp signature on selected page
pdftk "$to_be_signed_page" stamp "$sig_pdf2" output "$signed_page"

# Extract first pages of full PDF
pdftk "$full_pdf" cat "$header_indices" output "$header_pdf"

# Concatenate header and signed page
pdftk "$header_pdf" "$signed_page" cat output "$final_pdf"

echo "Signed full PDF saved to $final_pdf"

zathura "$signed_page"
