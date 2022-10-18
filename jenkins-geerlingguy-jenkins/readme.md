Установка Jenkins используя Ansible и плагин Configuration as Code на виртуальной машине

Jenkins Configuration as Code (aka JCasC) призвана быть инструментом, который позволяет вам запускать свой Jenkins в парадигме Infrastructure as Code или инфраструктура как код (IaC).

Этот пост будет состоять из двух частей. Первая часть - быстрый запуск тестового примера. Вторая часть - подробное описание.
<cut />
Для быстрого запуска тестового примера будем использовать Yandex Cloud. Клонируем репозиторий, указываем креды Yandex cloud и запускаем установку.

Первая часть. Быстрый запуск тестового примера.

Перед установкой необходимо установить необходимые утилиты. Подробнее в readme репозитория https://github.com/patsevanton/infrastructure-as-a-code-example/blob/main/README.md
Скачиваем репозиторий:
```
git clone https://github.com/patsevanton/infrastructure-as-a-code-example.git
cd jenkins-geerlingguy-jenkins
cp private.auto.tfvars.example private.auto.tfvars
```
Заполняем указываем креды Yandex cloud в private.auto.tfvars.
Запускаем установку Jenkins:
```
jenkins_install.sh
```

Вторая часть. Подробное описание.

В файле private.auto.tfvars указываем ресурсы виртуальной машины. Я использую sslip.io для резолвинга DNS динамического IP. Вы можете использовать другие варианты.

В jenkins_install.sh с помощью Ansible устанавливаются java, jenkins, nginx и генерируется letsencrypt сертификат.

Файл inventory https://github.com/patsevanton/infrastructure-as-a-code-example/blob/main/jenkins-geerlingguy-jenkins/inventory_yml.tpl создается из шаблона terraform. Разберем его.


При использовании роль geerlingguy.ansible-role-jenkins нельзя указать точную LTS версию Jenkins. Issue - https://github.com/geerlingguy/ansible-role-jenkins/issues/359:
```
    jenkins_prefer_lts: true
    #jenkins_version: "2.346"
```

Параметры letsencrypt ansible роли. Регистрируем letsencrypt без указания email и используем http проверку домена:
```
    letsencrypt_opts_extra: "--register-unsafely-without-email"
    letsencrypt_cert:
      name: ${hostname}.${public_ip}.${domain}
      domains:
        - ${hostname}.${public_ip}.${domain}
      challenge: http
      http_auth: standalone
      reuse_key: True
```
После того как сгенерироваться letsencrypt устанавливаем и настраиваем nginx c помощью роли geerlingguy.nginx. В конфигурации удаляем виртуальных хост default, который используется по умолчанию и настраиваем виртуальный хост для jenkins:
```
    nginx_remove_default_vhost: true
    nginx_vhosts:
      - listen: "80"
        server_name: "${hostname}.${public_ip}.${domain}"
        return: "301 https://${hostname}.${public_ip}.${domain}$request_uri"
        filename: "${hostname}.${public_ip}.${domain}.80.conf"
      - listen: "443 ssl"
        server_name: ${hostname}.${public_ip}.${domain}
        state: "present"
        extra_parameters: |
          location / {
            proxy_set_header        Host $host:$server_port;
            proxy_set_header        X-Real-IP $remote_addr;
            proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header        X-Forwarded-Proto $scheme;

            # Fix the "It appears that your reverse proxy set up is broken" error.
            proxy_pass          http://127.0.0.1:8080;
            proxy_read_timeout  90;

          }
          ssl_certificate     /etc/letsencrypt/live/${hostname}.${public_ip}.${domain}/cert.pem;
          ssl_certificate_key /etc/letsencrypt/live/${hostname}.${public_ip}.${domain}/privkey.pem;
```


Рассмотрим playbook.yml. Jenkins устанавливается как systemd сервис. Установку и настройку Jenkins в Kubernetes думаю протестировать в будущем. 
После того как Jenkins установлен небходимо допилить его напильником или донастроить. 
Создаем директорию /var/lib/jenkins/jcasc и помещаем туда файл конфигурации плагина Jenkins Configuration as Code (aka JCasC).
Описание jcasc.yaml рассмотрим ниже:
```
    - name: Create directory /var/lib/jenkins/jcasc
      ansible.builtin.file:
        path: /var/lib/jenkins/jcasc
        state: directory
        owner: jenkins
        group: jenkins

    - name: Copy jcasc.yaml with owner and permissions
      ansible.builtin.copy:
        src: jcasc.yaml
        dest: /var/lib/jenkins/jcasc/jcasc.yaml
        owner: jenkins
        group: jenkins
        mode: '0644'
```

Далее необходимо сделать override systemd сервиса jenkins и добавить environment переменную чтобы плагин Jenkins Configuration as Code (aka JCasC) заработал. Для этого используем репозиторий https://github.com/MatthewRFennell/ansible-role-jenkins/tree/use-systemd-instead-of-init.
Устанавливаем роль из этого репозитория:
```
ansible-galaxy install --force git+https://github.com/MatthewRFennell/ansible-role-jenkins.git,use-systemd-instead-of-init
```
Из этого репозитория в репозиторий geerlingguy/ansible-role-jenkins сделан pull request https://github.com/geerlingguy/ansible-role-jenkins/pull/354.

Добавляем env переменную `CASC_JENKINS_CONFIG` в inventory. Так как JAVA_OPTS  перезатирается, то в нее тоже добавляем ``-Djenkins.install.runSetupWizard=false`` 
```
    jenkins_java_options: "-Djava.awt.headless=true -Djenkins.install.runSetupWizard=false"

    jenkins_init_changes:
      - option: "JAVA_OPTS"
        value: "{{ jenkins_java_options }}"
      - option: "CASC_JENKINS_CONFIG"
        value: "/var/lib/jenkins/jcasc/"
```

Далее идет установка jenkins плагинов через jenkins-plugin-manager. Скрипт установки Jenkins плагинов (https://github.com/jenkinsci/docker/blob/master/install-plugins.sh) устарел и был удален из репозитория. В директории files находимя файл plugins.txt, в котором список плагинов для установки.


Так же заведена issue в community.general.jenkins_plugin. По умолчанию with_dependencies включена, но она не работает - https://github.com/ansible-collections/community.general/issues/4995.

Дальше идет генерация api token для текущего юзера admin:
```
    - name: Generate generate-jenkins-api-token.sh from template
      template:
        src: generate-jenkins-api-token.sh.j2
        dest: /var/lib/jenkins/generate-jenkins-api-token.sh
        owner: jenkins
        group: jenkins
        mode: 0755

    - name: Create API token from script
      shell: "/var/lib/jenkins/generate-jenkins-api-token.sh"
      register: script_api_token_output
      args:
        creates: /var/lib/jenkins/api_token.txt

    - name: Read api_token from /var/lib/jenkins/api_token.txt
      slurp:
        src: /var/lib/jenkins/api_token.txt
      register: api_token

    - name: Set fact api_token
      set_fact:
        api_token: "{{ api_token.content | b64decode }}"
```

Содержимое файла generate-jenkins-api-token.sh. Правильный скрипт генерации api token нашел только в одном месте: https://stackoverflow.com/a/72906138/3698532. Остальные скрипты не работали. Переработанный рабочий скрипт:

```
#!/bin/bash

FILE=/var/lib/jenkins/api_token.txt

if [ -f "$FILE" ]; then
    echo "$FILE exists."
else 
    echo "$FILE does not exist."
    JENKINS_URL="http://localhost:8080"
    JENKINS_USER=admin
    JENKINS_USER_PASS={{ jenkins_admin_password }}

    JENKINS_CRUMB=$(curl -u "$JENKINS_USER:$JENKINS_USER_PASS" -s --cookie-jar /tmp/cookies $JENKINS_URL'/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,":",//crumb)')

    ACCESS_TOKEN=$(curl -u "$JENKINS_USER:$JENKINS_USER_PASS" -H $JENKINS_CRUMB -s \
                        --cookie /tmp/cookies $JENKINS_URL'/me/descriptorByName/jenkins.security.ApiTokenProperty/generateNewToken' \
                        --data 'newTokenName=GlobalToken' | jq -r '.data.tokenValue')

    echo $ACCESS_TOKEN > /var/lib/jenkins/api_token.txt
fi
```

Далее генерируем job с помощью jenkins-job-builder:
```
    - name: Generate jenkins-jobs-config from template
      template:
        src: jenkins-jobs-config.j2
        dest: /var/lib/jenkins/jenkins-jobs-config
        owner: jenkins
        group: jenkins
        mode: 0644

    - name: Create directory /var/lib/jenkins/jobs
      ansible.builtin.file:
        path: /var/lib/jenkins/jobs
        state: directory
        owner: jenkins
        group: jenkins
        mode: '0755'

    - name: Copy job-template.yaml
      ansible.builtin.copy:
        src: job-template.yaml
        dest: /var/lib/jenkins/jobs/job-template.yaml
        owner: jenkins
        group: jenkins

    - name: Copy defaults.yaml
      ansible.builtin.copy:
        src: defaults.yaml
        dest: /var/lib/jenkins/jobs/defaults.yaml
        owner: jenkins
        group: jenkins

    - name: Copy projects.yaml
      ansible.builtin.copy:
        src: projects.yaml
        dest: /var/lib/jenkins/jobs/projects.yaml
        owner: jenkins
        group: jenkins

    - name: Create Jenkins jobs using Jenkins job builder
      shell: "jenkins-jobs --conf=jenkins-jobs-config update jobs"
      register: jenkins_job_builder_output
      args:
        chdir: /var/lib/jenkins
```

Описание файлов конфигурации jenkins-job-builder
defaults.yaml:
```
- defaults:
    name: global
    logrotate:
      daysToKeep: 30
      numToKeep: 5
      artifactDaysToKeep: -1
      artifactNumToKeep: -1
``` 
job-template.yaml:
```
- project:
    name: project-example
    jobs:
      - '{name}_job':
          name: getspace
          command: df -h
      - '{name}_job':
          name: listEtc
          command: ls /etc
```
Эти файлы конфигурации были взяты из практического видео по jenkins-job-builder: https://www.youtube.com/watch?v=SoP05dLe5kA


В конце playbook подкладываем измененый конфиг jcasc.yaml
```
- name: Enable googleOAuth2
  hosts: jenkins
  become: true
  tasks:
    - name: Copy jcasc_googleoauth2.yaml
      ansible.builtin.copy:
        src: jcasc_googleoauth2.yaml
        dest: /var/lib/jenkins/jcasc/jcasc.yaml
        owner: jenkins
        group: jenkins
        mode: '0644'
      register: jcasc_googleoauth2_yaml

    - name: Restart service jenkins
      ansible.builtin.systemd:
        state: restarted
        daemon_reload: yes
        name: jenkins
      when: jcasc_googleoauth2_yaml.changed
```

В конфиге указываем что вход осуществляется с помощью Google учетки. Идем в `APIs & serivces` вашего проекта в https://console.developers.google.com, создаем новые `credentials`, выбираем `OAuth client ID`, выбираем `Application Type`: `Web Application`. Выбираем название `name`. В `Authorized JavaScript origins` указываем URI ссылку, ведущую на ваш jenkins сайт (я использовать HTTPS в URL). В `Authorized redirect URIs` указываем ${ваш-jenkins-сайт}/securityRealm/finishLogin. Полученные clientId и clientSecret указываем в конфиге jcasc_googleoauth2.yaml. В `domain` указываем домен, с которого можно входить в этот Jenkins.
```
jenkins:
  securityRealm:
    googleOAuth2:
      # https://stackoverflow.com/questions/17699656/how-to-configure-jenkins-login-with-google-apps
      # The Client ID from the https://console.developers.google.com/
      clientId: "xxx-xxx.apps.googleusercontent.com"
      # The Client Secret from the Google Developer Console.
      clientSecret: "xxx-xxx"
      # Optional. If present, access to Jenkins will be restricted to users in the provided Google Apps Domain.
      #           A comma separated list can be used to specify multiple domains.
      domain: ""
```
