using Microsoft.EntityFrameworkCore;
using SIMS.SimsDbContext.Entities;
using SIMS.Models;

namespace SIMS.SimsDbContext
{
    public class SimDbContext : DbContext
    {
        public SimDbContext(DbContextOptions<SimDbContext> options) : base(options) { }

        // DbSet cho Users (đã có)
        public DbSet<Users> User { get; set; }

        // DbSet cho Courses (thêm mới)
        public DbSet<Course> Courses { get; set; }

        // DbSet cho Students (thêm mới)
        public DbSet<Student> Students { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            // Cấu hình cho Users (giữ nguyên)
            modelBuilder.Entity<Users>().ToTable("Users");
            modelBuilder.Entity<Users>().HasKey("Id");
            modelBuilder.Entity<Users>().HasIndex("Username").IsUnique();
            modelBuilder.Entity<Users>().HasIndex("Email").IsUnique();
            modelBuilder.Entity<Users>().Property(u => u.Status).HasDefaultValue("Active");
            modelBuilder.Entity<Users>().Property(u => u.Role).HasDefaultValue("Admin");

            // Cấu hình cho Courses (thêm mới)
            modelBuilder.Entity<Course>(entity =>
            {
                entity.ToTable("Courses");
                entity.HasKey(e => e.CourseId);
                entity.Property(e => e.CourseCode).IsRequired().HasMaxLength(20);
                entity.Property(e => e.CourseName).IsRequired().HasMaxLength(200);
                entity.Property(e => e.Description).HasMaxLength(1000);
                entity.Property(e => e.Instructor).HasMaxLength(100);
                entity.Property(e => e.Credits).IsRequired();
                entity.Property(e => e.IsActive).HasDefaultValue(true);
                entity.Property(e => e.CreatedDate).HasDefaultValueSql("GETDATE()");

                // Index cho CourseCode để tìm kiếm nhanh và đảm bảo unique
                entity.HasIndex(e => e.CourseCode).IsUnique();
            });

            // Cấu hình cho Students (thêm mới)
            modelBuilder.Entity<Student>(entity =>
            {
                entity.ToTable("Students");
                entity.HasKey(e => e.StudentId);
                entity.Property(e => e.StudentCode).IsRequired().HasMaxLength(20);
                entity.Property(e => e.FullName).IsRequired().HasMaxLength(100);
                entity.Property(e => e.Email).IsRequired().HasMaxLength(100);
                entity.Property(e => e.Phone).HasMaxLength(20);
                entity.Property(e => e.Gender).HasMaxLength(10);
                entity.Property(e => e.Address).HasMaxLength(200);
                entity.Property(e => e.Major).HasMaxLength(50);
                entity.Property(e => e.Notes).HasMaxLength(500);
                entity.Property(e => e.IsActive).HasDefaultValue(true);
                entity.Property(e => e.CreatedDate).HasDefaultValueSql("GETDATE()");

                // Index cho StudentCode và Email để tìm kiếm nhanh và đảm bảo unique
                entity.HasIndex(e => e.StudentCode).IsUnique();
                entity.HasIndex(e => e.Email).IsUnique();
            });
        }
    }
}