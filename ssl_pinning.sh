#!/bin/bash

# Copyright 2020 Eduardo Gorio

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Variáveis
CERTIFICADO=certificate.crt

# Método para obter certificado
# Parâmetros: 
#   URL, 
#   URL PORTA, 
#   URL:PORTA, 
#   URL PORTA ARQUIVO
obter_certificado() {
    PORTA=443

    # Verifica se digitou 1 ou mais parâmetros
    if (( $# == 1 )); then
        DOMINIO=$1
        if [[ $1 == *":"* ]]; then
            aux=$1
            DOMINIO=${aux%:*}
            PORTA=${aux##*:}
        fi
    elif (( $# == 2 )); then
        DOMINIO=$1
        if [[ $2 == *"."* ]]; then
            CERTIFICADO=$2
        else
            PORTA=$2
        fi
    elif (( $# == 3 )); then
         DOMINIO=$1
         PORTA=$2
         CERTIFICADO=$3
    else
        echo "Parâmetros inválidos"
        echo "  obter_certificado <URL>"
        echo "  obter_certificado <URL> <PORTA>"
        echo "  obter_certificado <URL> <PORTA> <ARQUIVO>"
    fi

    # Comando para obter certificado de um domínio
    echo | openssl s_client -servername $DOMINIO -connect $DOMINIO:$PORTA -showcerts | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > $CERTIFICADO
}

obter_data() {

    if (( $# == 1 )); then
        CERTIFICADO=$1
    fi

    # Comando para obter a data de vencimento de um certificado
    # DATA=`openssl x509 -enddate -noout -in $CERTIFICADO | grep notAfter | sed -e 's#notAfter=##'`
    echo | openssl x509 -enddate -noout -in $CERTIFICADO | grep notAfter | sed -e 's#notAfter=##'

}

# Método principal
main_menu() {
    obter_certificado mobilepessoafisica2.itau.com.br
    obter_certificado mobilepessoafisica2.itau.com.br 443
    obter_certificado mobilepessoafisica2.itau.com.br:443
    obter_certificado mobilepessoafisica2.itau.com.br mobilepessoafisica2.crt
    obter_certificado
    obter_data
}

main_menu


# # Comando para obter fingerprint (sha256) de um certificado
# echo | openssl x509 -noout -fingerprint -sha256 -inform pem -in $CERTIFICADO

# # Comando para obter fingerprint (sha1) de um certificado
# echo | openssl x509 -noout -fingerprint -sha1 -inform pem -in $CERTIFICADO

# # Comando para obter fingerprint (md5) de um certificado
# echo | openssl x509 -noout -fingerprint -md5 -inform pem -in $CERTIFICADO

# # Comando para obter o domínio de um certificado
# DOMINIO=`openssl x509 -noout -subject -in $CERTIFICADO | egrep -o '[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,4}'`

# # Comando para obter hash para pinagem Android
# hash=`openssl x509 -in $CERTIFICADO -pubkey -noout | openssl rsa -pubin -outform der | openssl dgst -sha256 -binary | openssl enc -base64`