#import <Foundation/Foundation.h>
#import <stdio.h>
#import <stdlib.h>

#import "ArlenServer.h"
#import "Controllers/HomeController.h"

static NSString *ALNEnvValue(const char *name) {
  const char *value = getenv(name);
  if (value == NULL || value[0] == '\0') {
    return nil;
  }
  return [NSString stringWithUTF8String:value];
}

static NSString *ALNResolveAppRoot(void) {
  NSString *override = ALNEnvValue("ARLEN_APP_ROOT");
  NSString *cwd = [[NSFileManager defaultManager] currentDirectoryPath];
  if ([override length] == 0) {
    return cwd;
  }
  if ([override hasPrefix:@"/"]) {
    return [override stringByStandardizingPath];
  }
  return [[cwd stringByAppendingPathComponent:override] stringByStandardizingPath];
}

static void PrintUsage(void) {
  fprintf(stdout,
          "Usage: boomhauer [--port <port>] [--host <addr>] [--env <env>] [--once] [--print-routes]\n");
}

int main(int argc, const char *argv[]) {
  @autoreleasepool {
    int portOverride = 0;
    NSString *host = nil;
    NSString *environment = @"development";
    BOOL once = NO;
    BOOL printRoutes = NO;
    for (int idx = 1; idx < argc; idx++) {
      NSString *arg = [NSString stringWithUTF8String:argv[idx]];
      if ([arg isEqualToString:@"--port"]) {
        if ((idx + 1) >= argc) {
          PrintUsage();
          return 2;
        }
        portOverride = atoi(argv[++idx]);
      } else if ([arg isEqualToString:@"--host"]) {
        if ((idx + 1) >= argc) {
          PrintUsage();
          return 2;
        }
        host = [NSString stringWithUTF8String:argv[++idx]];
      } else if ([arg isEqualToString:@"--env"]) {
        if ((idx + 1) >= argc) {
          PrintUsage();
          return 2;
        }
        environment = [NSString stringWithUTF8String:argv[++idx]];
      } else if ([arg isEqualToString:@"--once"]) {
        once = YES;
      } else if ([arg isEqualToString:@"--print-routes"]) {
        printRoutes = YES;
      } else if ([arg isEqualToString:@"--help"] || [arg isEqualToString:@"-h"]) {
        PrintUsage();
        return 0;
      } else {
        fprintf(stderr, "Unknown argument: %s\n", argv[idx]);
        return 2;
      }
    }

    NSString *appRoot = ALNResolveAppRoot();
    NSError *error = nil;
    ALNApplication *app = [[ALNApplication alloc] initWithEnvironment:environment
                                                           configRoot:appRoot
                                                                error:&error];
    if (app == nil) {
      fprintf(stderr, "failed loading config: %s\n", [[error localizedDescription] UTF8String]);
      return 1;
    }

    [app registerRouteMethod:@"GET"
                        path:@"/"
                        name:@"home"
             controllerClass:[HomeController class]
                      action:@"landing"];
    [app registerRouteMethod:@"GET"
                        path:@"/docs"
                        name:@"docs"
             controllerClass:[HomeController class]
                      action:@"docs"];
    [app registerRouteMethod:@"GET"
                        path:@"/docs/latest"
                        name:@"docs_latest"
             controllerClass:[HomeController class]
                      action:@"docsLatest"];
    [app registerRouteMethod:@"GET"
                        path:@"/guides/get-started"
                        name:@"guides_get_started"
             controllerClass:[HomeController class]
                      action:@"getStarted"];
    [app registerRouteMethod:@"GET"
                        path:@"/examples"
                        name:@"examples"
             controllerClass:[HomeController class]
                      action:@"showcase"];
    [app registerRouteMethod:@"GET"
                        path:@"/showcase"
                        name:@"showcase"
             controllerClass:[HomeController class]
                      action:@"showcase"];
    [app registerRouteMethod:@"GET"
                        path:@"/download"
                        name:@"download"
             controllerClass:[HomeController class]
                      action:@"download"];
    [app registerRouteMethod:@"GET"
                        path:@"/dogfood"
                        name:@"dogfood"
             controllerClass:[HomeController class]
                      action:@"dogfood"];
    [app registerRouteMethod:@"GET"
                        path:@"/healthz"
                        name:@"healthz"
             controllerClass:[HomeController class]
                      action:@"healthz"];

    ALNHTTPServer *server =
        [[ALNHTTPServer alloc] initWithApplication:app
                                            publicRoot:[appRoot stringByAppendingPathComponent:@"public"]];
    server.serverName = @"boomhauer";
    if (printRoutes) {
      [server printRoutesToFile:stdout];
      return 0;
    }
    return [server runWithHost:host portOverride:portOverride once:once];
  }
}
