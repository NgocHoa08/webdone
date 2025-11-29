using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.EntityFrameworkCore;
using SIMS.Interfaces;
using SIMS.Repositories;
using SIMS.Services;
using SIMS.SimsDbContext;

namespace SIMS
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);
            builder.Services.AddDbContext<SimDbContext>(options =>
                options.UseSqlServer(
                    builder.Configuration.GetConnectionString("DefaultConnection"),
                    sqlOptions => sqlOptions.EnableRetryOnFailure(
                        maxRetryCount: 5,
                        maxRetryDelay: TimeSpan.FromSeconds(10),
                        errorNumbersToAdd: null)));

            // Repository và Service cho User
            builder.Services.AddScoped<IUserRepository, UserRepository>();
            builder.Services.AddScoped<UserService>();

            // Repository và Service cho Course
            builder.Services.AddScoped<ICourseRepository, CourseRepository>();
            builder.Services.AddScoped<CourseService>();

            // Repository và Service cho Student
            builder.Services.AddScoped<IStudentRepository, StudentRepository>();
            builder.Services.AddScoped<StudentService>();

            builder.Services.AddControllersWithViews();
            builder.Services.AddHttpContextAccessor();
            builder.Services.AddAuthentication(CookieAuthenticationDefaults.AuthenticationScheme).AddCookie(options =>
            {
                options.LoginPath = "/Login";
                options.AccessDeniedPath = "/Authencation/AccessDenied";
                options.LogoutPath = "/Login/Logout";
            });
            //phan quyen
            builder.Services.AddAuthorization(options =>
            {
                options.AddPolicy("AdminOnly", policy => policy.RequireRole("Administrator"));
                options.AddPolicy("Student", policy => policy.RequireRole("User"));
                options.AddPolicy("FalcultyOnly", policy => policy.RequireRole("Manager"));
                options.AddPolicy("StaffOnly", policy => policy.RequireRole("Staff"));
            });
            var app = builder.Build();

            if (!app.Environment.IsDevelopment())
            {
                app.UseExceptionHandler("/Home/Error");
                app.UseHsts();
            }

            app.UseHttpsRedirection();
            app.UseStaticFiles();
            app.UseRouting();
            app.UseAuthentication();  // Quan trọng: phải có trước UseAuthorization
            app.UseAuthorization();

            app.MapControllerRoute(
                name: "default",
                pattern: "{controller=Login}/{action=Index}/{id?}");

            app.Run();
        }
    }
}