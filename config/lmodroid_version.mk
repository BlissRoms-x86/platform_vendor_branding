# Copyright (C) 2020 The PixelExperience Project
# Copyright (C) 2020 The LibreMobileOS Foundation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# LMODroid versions
LMODROID_BUILD_TYPE ?= UNOFFICIAL

DATE_YEAR := $(shell date -u +%y)
DATE_MONTH := $(shell date -u +%m)
DATE_DAY := $(shell date -u +%d)
DATE_HOUR := $(shell date -u +%H)
DATE_MINUTE := $(shell date -u +%M)
BUILD_DATE_UTC := $(shell date -d '$(DATE_YEAR)-$(DATE_MONTH)-$(DATE_DAY) $(DATE_HOUR):$(DATE_MINUTE) UTC' +%s)
BUILD_DATE := $(DATE_YEAR)$(DATE_MONTH)$(DATE_DAY)-$(DATE_HOUR)$(DATE_MINUTE)

LMODROID_VERSION := 2.0

TARGET_PRODUCT_SHORT := $(subst lmodroid_,,$(LMODROID_BUILD))

LMODROID_BUILD_NAME := LMODroid-$(LMODROID_BUILD)-$(LMODROID_VERSION)-$(BUILD_DATE)-$(LMODROID_BUILD_TYPE)

LMODROID_PROPERTIES := \
    ro.lmodroid.build_name=$(LMODROID_BUILD_NAME) \
    ro.lmodroid.build_date=$(BUILD_DATE) \
    ro.lmodroid.build_date_utc=$(BUILD_DATE_UTC) \
    ro.lmodroid.build_type=$(LMODROID_BUILD_TYPE) \
    ro.lmodroid.version=$(LMODROID_VERSION)
