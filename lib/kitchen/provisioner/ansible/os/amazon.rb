# -*- encoding: utf-8 -*-
#
# Author:: Michael Heap (<m@michaelheap.com>)
#
# Copyright (C) 2015 Michael Heap
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

module Kitchen
  module Provisioner
    module Ansible
      class Os
        class Amazon < Redhat
          def install_command
            <<-INSTALL

            if [ ! $(which ansible) ]; then
              #{install_epel_repo}
              #{sudo_env('yum-config-manager')} --enable epel/x86_64
              #{sudo_env('yum')} -y install git

              if `grep -q "Amazon Linux AMI" /etc/os-release`; then
                ## Amazon Linux 1
                #{sudo_env('yum')} -y install #{ansible_package_name}
                #{sudo_env('alternatives')} --set python /usr/bin/python2.6
                #{sudo_env('yum')} clean all
                #{sudo_env('yum')} install yum-python26 -y
              else
                ## Amazon Linux 2
                #{sudo_env('amazon-linux-extras')} install -y ansible2
              fi
            fi
            INSTALL
          end
        end
      end
    end
  end
end
