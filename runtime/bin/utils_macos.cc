// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

#include "platform/globals.h"
#if defined(HOST_OS_MACOS)

#include <errno.h>           // NOLINT
#include <mach/clock.h>      // NOLINT
#include <mach/mach.h>       // NOLINT
#include <mach/mach_time.h>  // NOLINT
#include <netdb.h>           // NOLINT
#include <sys/time.h>  // NOLINT
#include <time.h>      // NOLINT

#include "bin/utils.h"
#include "platform/assert.h"
#include "platform/utils.h"

namespace dart {
namespace bin {

OSError::OSError() : sub_system_(kSystem), code_(0), message_(NULL) {
  Reload();
}

void OSError::Reload() {
  SetCodeAndMessage(kSystem, errno);
}

void OSError::SetCodeAndMessage(SubSystem sub_system, int code) {
  set_sub_system(sub_system);
  set_code(code);
  if (sub_system == kSystem) {
    const int kBufferSize = 1024;
    char error_message[kBufferSize];
    Utils::StrError(code, error_message, kBufferSize);
    SetMessage(error_message);
  } else if (sub_system == kGetAddressInfo) {
    SetMessage(gai_strerror(code));
  } else {
    UNREACHABLE();
  }
}

const char* StringUtils::ConsoleStringToUtf8(const char* str,
                                             intptr_t len,
                                             intptr_t* result_len) {
  UNIMPLEMENTED();
  return NULL;
}

const char* StringUtils::Utf8ToConsoleString(const char* utf8,
                                             intptr_t len,
                                             intptr_t* result_len) {
  UNIMPLEMENTED();
  return NULL;
}

char* StringUtils::ConsoleStringToUtf8(char* str,
                                       intptr_t len,
                                       intptr_t* result_len) {
  UNIMPLEMENTED();
  return NULL;
}

char* StringUtils::Utf8ToConsoleString(char* utf8,
                                       intptr_t len,
                                       intptr_t* result_len) {
  UNIMPLEMENTED();
  return NULL;
}

bool ShellUtils::GetUtf8Argv(int argc, char** argv) {
  return false;
}

static mach_timebase_info_data_t timebase_info;

void TimerUtils::InitOnce() {
  kern_return_t kr = mach_timebase_info(&timebase_info);
  ASSERT(KERN_SUCCESS == kr);
}

int64_t TimerUtils::GetCurrentMonotonicMillis() {
  return GetCurrentMonotonicMicros() / 1000;
}

int64_t TimerUtils::GetCurrentMonotonicMicros() {
  ASSERT(timebase_info.denom != 0);
  // timebase_info converts absolute time tick units into nanoseconds.  Convert
  // to microseconds.
  int64_t result = mach_absolute_time() / kNanosecondsPerMicrosecond;
  result *= timebase_info.numer;
  result /= timebase_info.denom;
  return result;
}

void TimerUtils::Sleep(int64_t millis) {
  struct timespec req;  // requested.
  struct timespec rem;  // remainder.
  int64_t micros = millis * kMicrosecondsPerMillisecond;
  int64_t seconds = micros / kMicrosecondsPerSecond;
  micros = micros - seconds * kMicrosecondsPerSecond;
  int64_t nanos = micros * kNanosecondsPerMicrosecond;
  req.tv_sec = seconds;
  req.tv_nsec = nanos;
  while (true) {
    int r = nanosleep(&req, &rem);
    if (r == 0) {
      break;
    }
    // We should only ever see an interrupt error.
    ASSERT(errno == EINTR);
    // Copy remainder into requested and repeat.
    req = rem;
  }
}

}  // namespace bin
}  // namespace dart

#endif  // defined(HOST_OS_MACOS)