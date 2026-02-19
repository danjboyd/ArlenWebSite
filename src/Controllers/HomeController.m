#import "HomeController.h"

#import <stdlib.h>

#import "ALNContext.h"
#import "ALNRequest.h"

@interface HomeController ()
- (NSMutableDictionary *)baseContextWithTitle:(NSString *)title
                                   description:(NSString *)description
                                     activeNav:(NSString *)activeNav;
@end

static id RenderTemplateOr500(HomeController *controller, NSString *templateName,
                              NSDictionary *viewContext) {
  NSError *error = nil;
  BOOL rendered = [controller renderTemplate:templateName
                                     context:viewContext
                                      layout:@"layouts/main"
                                       error:&error];
  if (!rendered) {
    [controller setStatus:500];
    [controller renderText:[NSString stringWithFormat:@"render failed for %@: %@",
                                                      templateName,
                                                      error.localizedDescription ?: @"unknown"]];
  }
  return nil;
}

@implementation HomeController

- (NSMutableDictionary *)baseContextWithTitle:(NSString *)title
                                   description:(NSString *)description
                                     activeNav:(NSString *)activeNav {
  NSInteger year =
      [[NSCalendar currentCalendar] component:NSCalendarUnitYear fromDate:[NSDate date]];
  return [@{
    @"pageTitle" : title ?: @"Arlen",
    @"metaDescription" : description ?: @"Arlen web application",
    @"activeNav" : activeNav ?: @"",
    @"logoPath" : @"/static/branding/arlen-logo.svg",
    @"docsLatestURL" : @"/static/docs/latest/index.html",
    @"year" : [NSString stringWithFormat:@"%ld", (long)year],
  } mutableCopy];
}

- (id)landing:(ALNContext *)ctx {
  (void)ctx;
  NSMutableDictionary *viewContext =
      [self baseContextWithTitle:@"Arlen | Modern MVC for Cocoa and GNUstep"
                      description:
                          @"Arlen is a convention-first, production-ready MVC framework for Cocoa and "
                          @"GNUstep."
                        activeNav:@"home"];

  viewContext[@"heroHeadline"] = @"The modern MVC framework for Cocoa-native web apps.";
  viewContext[@"heroLead"] =
      @"Inspired by proven convention-first web architecture and built on Cocoa/GNUstep foundations, "
      @"Arlen gives teams a coherent stack to ship predictable releases without framework churn.";
  viewContext[@"quickstartCommand"] =
      @"arlen new InventoryApp\n"
      @"cd InventoryApp\n"
      @"arlen boomhauer --port 3000";
  viewContext[@"heroSpotlights"] = @[
    @{
      @"id" : @"convention",
      @"label" : @"Convention-first MVC",
      @"title" : @"One predictable path from route to response",
      @"outcome" :
          @"Teams spend less time arguing architecture and more time shipping features because "
          @"the framework gives clear defaults for controllers, views, and structure.",
      @"code" :
          @"[app registerRouteMethod:@\"GET\"\n"
          @"                    path:@\"/posts/:id\"\n"
          @"                    name:@\"posts_show\"\n"
          @"         controllerClass:[PostsController class]\n"
          @"                  action:@\"show\"];\n"
          @"\n"
          @"- (id)show:(ALNContext *)ctx {\n"
          @"  return [self renderTemplate:@\"posts/show\" context:@{} layout:@\"layouts/main\" "
          @"error:nil];\n"
          @"}\n",
      @"docsHref" : @"/docs/latest/docs/CORE_CONCEPTS.html",
      @"docsLabel" : @"Read core concepts"
    },
    @{
      @"id" : @"templates",
      @"label" : @"Compiled EOC templates",
      @"title" : @"Template feedback happens before production traffic",
      @"outcome" :
          @"Compiled templates catch issues earlier, keep escaping explicit, and let teams build "
          @"server-rendered interfaces that stay easy to maintain.",
      @"code" :
          @"<% ALNEOCInclude(out, ctx, @\"partials/_flash.html.eoc\", error); %>\n"
          @"<h1><%= [post title] %></h1>\n"
          @"<p><%= [post summary] %></p>\n"
          @"\n"
          @"<% for (Comment *comment in [ctx objectForKey:@\"comments\"]) { %>\n"
          @"  <li><%= [comment body] %></li>\n"
          @"<% } %>\n",
      @"docsHref" : @"/docs/latest/docs/CORE_CONCEPTS.html",
      @"docsLabel" : @"Read view/template docs"
    },
    @{
      @"id" : @"migrations",
      @"label" : @"Built-in migrations + process manager",
      @"title" : @"Schema and runtime operations stay in one workflow",
      @"outcome" :
          @"Versioned migrations and first-class process controls reduce deploy risk and make "
          @"production behavior more repeatable.",
      @"code" :
          @"$ /path/to/Arlen/bin/arlen generate migration AddInvoices\n"
          @"$ /path/to/Arlen/bin/arlen migrate --env production\n"
          @"\n"
          @"-- db/migrations/2026021901_add_invoices.sql\n"
          @"alter table invoices add column due_on date;\n"
          @"\n"
          @"# run workers under a propane production profile",
      @"docsHref" : @"/docs/latest/docs/DEPLOYMENT.html",
      @"docsLabel" : @"Read deployment docs"
    },
    @{
      @"id" : @"routing",
      @"label" : @"Deterministic routing",
      @"title" : @"Request matching is explicit, stable, and easy to inspect",
      @"outcome" :
          @"Routes are registered directly in application code, so teams can trace behavior "
          @"without hidden magic or framework guesswork.",
      @"code" :
          @"[app registerRouteMethod:@\"GET\" path:@\"/\" name:@\"home\"\n"
          @"         controllerClass:[HomeController class] action:@\"landing\"];\n"
          @"[app registerRouteMethod:@\"GET\" path:@\"/docs\" name:@\"docs\"\n"
          @"         controllerClass:[HomeController class] action:@\"docs\"];\n"
          @"[app registerRouteMethod:@\"GET\" path:@\"/healthz\" name:@\"healthz\"\n"
          @"         controllerClass:[HomeController class] action:@\"healthz\"];\n",
      @"docsHref" : @"/docs/latest/docs/CORE_CONCEPTS.html",
      @"docsLabel" : @"Read routing docs"
    }
  ];
  viewContext[@"heroDemoPoints"] = @[
    @"Create a project, run locally, and start coding in one CLI flow.",
    @"Use the same framework for marketing pages, docs, and product routes.",
    @"Keep runtime behavior explicit from development to production."
  ];
  viewContext[@"proofItems"] = @[
    @"Convention-first routing and controllers keep request behavior readable.",
    @"Compiled templates and shared layouts support fast, maintainable server-rendered UI.",
    @"Built-in migrations, security defaults, and process management help teams ship confidently."
  ];
  viewContext[@"alleyLine"] =
      @"Straightforward architecture, predictable behavior, and just enough alley humor.";

  viewContext[@"featureSet"] = @[
    @{
      @"tag" : @"Routing",
      @"title" : @"Ship readable request flows from day one",
      @"description" :
          @"Conventional route registration and controller actions stay easy to reason about as "
          @"the app grows."
    },
    @{
      @"tag" : @"Views",
      @"title" : @"Render fast HTML without template guesswork",
      @"description" :
          @"Compiled EOC templates, layouts, and partials give teams quick feedback, safe "
          @"escaping, and maintainable server-rendered pages."
    },
    @{
      @"tag" : @"Data",
      @"title" : @"Evolve schema safely as product requirements change",
      @"description" :
          @"Built-in migrations and data tooling let you version schema changes explicitly and "
          @"deploy with confidence."
    },
    @{
      @"tag" : @"Security",
      @"title" : @"Harden defaults before the first production deploy",
      @"description" :
          @"Sessions, CSRF protections, rate limits, and headers are first-class framework "
          @"capabilities, not one-off patches."
    },
    @{
      @"tag" : @"Dev loop",
      @"title" : @"Keep iteration tight without server thrash",
      @"description" :
          @"Boomhauer watch mode rebuilds quickly and keeps the app running with actionable "
          @"diagnostics when edits fail."
    },
    @{
      @"tag" : @"Deploy",
      @"title" : @"Run multi-worker production with explicit controls",
      @"description" :
          @"Propane process management provides graceful reload behavior and predictable runtime "
          @"operations in production."
    }
  ];

  viewContext[@"workflowPillars"] = @[
    @{
      @"title" : @"Modern by design",
      @"description" :
          @"CLI-first app lifecycle with deterministic commands that fit CI/CD pipelines."
    },
    @{
      @"title" : @"Mature runtime, modern execution",
      @"description" :
          @"Cocoa/GNUstep gives you stable object foundations while Arlen provides current web "
          @"workflow patterns."
    },
    @{
      @"title" : @"One coherent stack",
      @"description" :
          @"Routes, controllers, templates, migrations, and process management are designed to "
          @"work together by default."
    },
    @{
      @"title" : @"Built for greenfield velocity",
      @"description" :
          @"Start fast with conventions, then keep architecture clean as teams and codebases "
          @"scale."
    }
  ];

  viewContext[@"codeSamples"] = @[
    @{
      @"id" : @"controller",
      @"label" : @"Controller",
      @"code" :
          @"- (id)index:(ALNContext *)ctx {\n"
          @"  NSArray *posts = [Post recentPublished:10 error:nil];\n"
          @"  return [self renderTemplate:@\"posts/index\"\n"
          @"                      context:@{ @\"posts\" : posts }\n"
          @"                       layout:@\"layouts/main\"\n"
          @"                        error:nil];\n"
          @"}\n"
    },
    @{
      @"id" : @"template",
      @"label" : @"Template",
      @"code" :
          @"<h1>Recent Posts</h1>\n"
          @"<% for (Post *post in [ctx objectForKey:@\"posts\"]) { %>\n"
          @"  <article>\n"
          @"    <h2><%= [post title] %></h2>\n"
          @"    <p><%= [post summary] %></p>\n"
          @"  </article>\n"
          @"<% } %>\n"
    },
    @{
      @"id" : @"migration",
      @"label" : @"Migration",
      @"code" :
          @"- (void)up:(ALNMigrationContext *)ctx {\n"
          @"  [ctx executeSQL:@\"create table if not exists posts (\"\n"
          @"                 @\"id bigserial primary key, \"\n"
          @"                 @\"title text not null, \"\n"
          @"                 @\"summary text not null, \"\n"
          @"                 @\"published_at timestamptz)\"\n"
          @"              error:nil];\n"
          @"}\n"
    }
  ];

  viewContext[@"comparisonRows"] = @[
    @{
      @"topic" : @"Framework philosophy",
      @"arlen" : @"Convention-first MVC with clear defaults and cohesive patterns",
      @"typical" : @"Loose toolkit assembly with inconsistent conventions"
    },
    @{
      @"topic" : @"Runtime foundation",
      @"arlen" : @"Stable Cocoa and GNUstep object model",
      @"typical" : @"Rapidly shifting runtime and package ecosystem"
    },
    @{
      @"topic" : @"Modern workflow fit",
      @"arlen" : @"CLI-first, CI/CD-friendly flow with compile-time feedback",
      @"typical" : @"Framework glue code and per-team workflow variance"
    },
    @{
      @"topic" : @"Production operations",
      @"arlen" : @"Built-in migrations + propane multi-worker process management",
      @"typical" : @"Separate third-party stack for schema and runtime operations"
    },
    @{
      @"topic" : @"Adoption path",
      @"arlen" : @"Familiar MVC concepts for iOS, macOS, and server developers",
      @"typical" : @"New abstractions with steeper relearning costs"
    },
  ];

  return RenderTemplateOr500(self, @"pages/home", viewContext);
}

- (id)docs:(ALNContext *)ctx {
  (void)ctx;
  NSMutableDictionary *viewContext =
      [self baseContextWithTitle:@"Arlen Docs | References, Guides, and API"
                      description:
                          @"Developer documentation for Arlen, including guides and generated API "
                          @"reference."
                        activeNav:@"docs"];

  viewContext[@"docVersions"] = @[
    @{
      @"name" : @"latest",
      @"label" : @"Live now",
      @"href" : @"/docs/latest",
      @"description" : @"Tracks the current framework guides, references, and API docs."
    },
    @{
      @"name" : @"v1.0",
      @"label" : @"Planned",
      @"href" : @"#",
      @"description" : @"Versioned docs will land at the first stable Arlen release."
    },
  ];

  viewContext[@"docTopics"] = @[
    @"Getting Started and first app workflow",
    @"CLI reference (`new`, `boomhauer`, `propane`, `migrate`)",
    @"Core concepts: routing, controllers, and EOC templates",
    @"Deployment and production operations"
  ];

  return RenderTemplateOr500(self, @"pages/docs", viewContext);
}

- (id)docsLatest:(ALNContext *)ctx {
  (void)ctx;
  [self redirectTo:@"/static/docs/latest/index.html" status:302];
  return nil;
}

- (id)getStarted:(ALNContext *)ctx {
  (void)ctx;
  NSMutableDictionary *viewContext =
      [self baseContextWithTitle:@"Arlen Guides | Get Started"
                      description:
                          @"Get a production-ready Arlen application running in minutes."
                        activeNav:@"guides"];

  viewContext[@"setupCommand"] =
      @"source /usr/GNUstep/System/Library/Makefiles/GNUstep.sh\n"
      @"/path/to/Arlen/bin/arlen new MyApp\n"
      @"cd MyApp";
  viewContext[@"runCommand"] = @"/path/to/Arlen/bin/arlen boomhauer --port 3000";
  viewContext[@"docsCommand"] =
      @"/path/to/Arlen/bin/arlen generate migration AddUsers\n"
      @"/path/to/Arlen/bin/arlen migrate --env development";

  return RenderTemplateOr500(self, @"pages/get_started", viewContext);
}

- (id)showcase:(ALNContext *)ctx {
  (void)ctx;
  NSMutableDictionary *viewContext =
      [self baseContextWithTitle:@"Arlen Showcase | What You Can Build"
                      description:@"Examples of application surfaces powered by Arlen."
                        activeNav:@"examples"];

  viewContext[@"showcaseItems"] = @[
    @{
      @"title" : @"Marketing + docs in one runtime",
      @"description" :
          @"Serve product pages, documentation, and application routes from one coherent runtime.",
      @"link" : @"/docs"
    },
    @{
      @"title" : @"Template-first developer UX",
      @"description" :
          @"Structured layouts, partials, and server-rendered views keep content and runtime "
          @"tightly aligned.",
      @"link" : @"/guides/get-started"
    },
    @{
      @"title" : @"Operational transparency",
      @"description" :
          @"Health checks and production logs make runtime behavior explicit and observable.",
      @"link" : @"/docs"
    }
  ];

  return RenderTemplateOr500(self, @"pages/showcase", viewContext);
}

- (id)download:(ALNContext *)ctx {
  (void)ctx;
  NSMutableDictionary *viewContext =
      [self baseContextWithTitle:@"Arlen Download | Install and Run"
                      description:@"Install Arlen and scaffold your first application."
                        activeNav:@"download"];

  viewContext[@"cloneCommand"] =
      @"git clone <your-arlen-repo-url> Arlen\n"
      @"cd Arlen\n"
      @"source /usr/GNUstep/System/Library/Makefiles/GNUstep.sh\n"
      @"make arlen";

  viewContext[@"scaffoldCommand"] =
      @"mkdir -p ~/arlen-apps\n"
      @"cd ~/arlen-apps\n"
      @"/path/to/Arlen/bin/arlen new MyApp\n"
      @"cd MyApp";

  viewContext[@"serveCommand"] = @"/path/to/Arlen/bin/arlen boomhauer --port 3000";
  return RenderTemplateOr500(self, @"pages/download", viewContext);
}

- (id)dogfood:(ALNContext *)ctx {
  NSString *appRootEnv = nil;
  const char *appRootRaw = getenv("ARLEN_APP_ROOT");
  if (appRootRaw != NULL && appRootRaw[0] != '\0') {
    appRootEnv = [NSString stringWithUTF8String:appRootRaw];
  }
  NSString *host = ctx.request.headers[@"host"] ?: @"127.0.0.1";
  NSString *path = ctx.request.path ?: @"/dogfood";
  return @{
    @"ok" : @(YES),
    @"framework" : @"Arlen",
    @"site" : @"Arlen Developer Website",
    @"message" : @"Arlen routes, controllers, and EOC templates are actively serving this response.",
    @"requestHost" : host,
    @"requestPath" : path,
    @"cwd" : [[NSFileManager defaultManager] currentDirectoryPath],
    @"arlenAppRootEnv" : appRootEnv ?: @"",
    @"docsLatest" : @"/static/docs/latest/index.html",
    @"timestamp" : [[NSDate date] description]
  };
}

- (id)healthz:(ALNContext *)ctx {
  (void)ctx;
  [self renderText:@"ok\n"];
  return nil;
}

@end
