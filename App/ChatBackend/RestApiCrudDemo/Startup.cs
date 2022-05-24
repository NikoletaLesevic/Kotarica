using MessagesBackend.Hubs;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.HttpsPolicy;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using ChatBackend.MessageData;
using ChatBackend.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using ChatBackend.Handlers;
using Microsoft.AspNetCore.Authentication;

namespace ChatBackend
{
    public class Startup
    {
        //readonly string MyAllowSpecificOrigins = "_myAllowSpecificOrigins";
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddSignalR();
            services.AddControllers();
            services.AddDbContext<MessageContext>(options => options.UseSqlite(Configuration.GetConnectionString("cs")));
            //services.AddDbContextPool<MessageContext>(options => options.UseSqlServer(Configuration.GetConnectionString("MessageContextConnectionString")));
            services.AddScoped<IMessageData, SqlMessageData>();
            services.AddScoped<ICommentData, SqlCommentData>();
            services.AddScoped<IUserData, SqlUserData>();
            services.AddScoped<IWishData, SqlWishData>();
            /* services.AddSwaggerGen(c =>
             {
                 c.SwaggerDoc("v1", new OpenApiInfo { Title = "ChatBackend", Version = "v1" });
             });*/

            services.AddCors(options =>
            {
                options.AddPolicy("_allowAnyOrigin",
                                  builder =>
                                  {
                                      builder.AllowAnyOrigin().AllowAnyHeader().AllowAnyMethod();
                                  });
            });

            services.AddAuthentication("BasicAuthentication")
                .AddScheme<AuthenticationSchemeOptions, BasicAuthenticationHandler>("BasicAuthentication", null);
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
              /*  app.UseSwagger();
                app.UseSwaggerUI(c => c.SwaggerEndpoint("/swagger/v1/swagger.json", "ChatBackend v1"));*/
            }

           //app.UseHttpsRedirection();

            app.UseRouting();
            app.UseCors("_allowAnyOrigin");
            app.UseAuthentication();
            app.UseAuthorization();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });
            app.UseEndpoints(endpoints =>
            {
                endpoints.MapHub<ChatHub>("chathub");
            });

            
        }
    }
}
