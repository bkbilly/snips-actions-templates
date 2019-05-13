#!/usr/bin/env python2
# -*- coding: utf-8 -*-

import ConfigParser
from hermes_python.hermes import Hermes
from hermes_python.ffi.utils import MqttOptions
from hermes_python.ontology import *
import io
import toml

CONFIGURATION_ENCODING_FORMAT = "utf-8"
CONFIG_INI = "config.ini"

class SnipsConfigParser(ConfigParser.SafeConfigParser):
    def to_dict(self):
        return {section : {option_name : option for option_name, option in self.items(section)} for section in self.sections()}


def read_configuration_file(configuration_file):
    try:
        with io.open(configuration_file, encoding=CONFIGURATION_ENCODING_FORMAT) as f:
            conf_parser = SnipsConfigParser()
            conf_parser.readfp(f)
            return conf_parser.to_dict()
    except (IOError, ConfigParser.Error) as e:
        return dict()

def subscribe_intent_callback(hermes, intentMessage):
    conf = read_configuration_file(CONFIG_INI)
    action_wrapper(hermes, intentMessage, conf)


def action_wrapper(hermes, intentMessage, conf):
    {{#each action_code as |a|}}{{a}}
    {{/each}}


if __name__ == "__main__":
    mqtt_opts = MqttOptions()
    snips_opts = toml.load('/etc/snips.toml')
    if 'mqtt' in snips_opts['snips-common']:
        mqtt_opts.broker_address = snips_opts['snips-common']['mqtt']
    if 'mqtt_username' in snips_opts['snips-common']:
        mqtt_opts.username = snips_opts['snips-common']['mqtt_username']
    if 'mqtt_password' in snips_opts['snips-common']:
        mqtt_opts.password = snips_opts['snips-common']['mqtt_password']
    if 'mqtt_tls_hostname' in snips_opts['snips-common']:
        mqtt_opts.tls_hostname = snips_opts['snips-common']['mqtt_tls_hostname']
    if 'mqtt_tls_disable_root_store' in snips_opts['snips-common']:
        mqtt_opts.tls_disable_root_store = snips_opts['snips-common']['mqtt_tls_disable_root_store']
    if 'mqtt_tls_cafile' in snips_opts['snips-common']:
        mqtt_opts.tls_ca_file = snips_opts['snips-common']['mqtt_tls_cafile']
    if 'mqtt_tls_capath' in snips_opts['snips-common']:
        mqtt_opts.tls_ca_path = snips_opts['snips-common']['mqtt_tls_capath']
    if 'mqtt_tls_client_cert' in snips_opts['snips-common']:
        mqtt_opts.tls_client_cert = snips_opts['snips-common']['mqtt_tls_client_cert']
    if 'mqtt_tls_client_key' in snips_opts['snips-common']:
        mqtt_opts.tls_client_key = snips_opts['snips-common']['mqtt_tls_client_key']

    with Hermes(mqtt_options=mqtt_opts) as h:
        h.subscribe_intent("{{intent_id}}", subscribe_intent_callback) \
         .start()
