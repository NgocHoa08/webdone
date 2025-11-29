using Microsoft.EntityFrameworkCore;
using SIMS.Interfaces;
using SIMS.Models;
using SIMS.SimsDbContext;

namespace SIMS.Repositories
{
    public class CourseRepository : ICourseRepository
    {
        private readonly SimDbContext _context;

        public CourseRepository(SimDbContext context)
        {
            _context = context;
        }

        public async Task<IEnumerable<Course>> GetAllCoursesAsync()
        {
            return await _context.Courses
                .OrderByDescending(c => c.CreatedDate)
                .ToListAsync();
        }

        public async Task<Course> GetCourseByIdAsync(int id)
        {
            return await _context.Courses.FindAsync(id);
        }

        public async Task<bool> AddCourseAsync(Course course)
        {
            try
            {
                course.CreatedDate = DateTime.Now;
                _context.Courses.Add(course);
                await _context.SaveChangesAsync();
                return true;
            }
            catch
            {
                return false;
            }
        }

        public async Task<bool> UpdateCourseAsync(Course course)
        {
            try
            {
                course.UpdatedDate = DateTime.Now;
                _context.Courses.Update(course);
                await _context.SaveChangesAsync();
                return true;
            }
            catch
            {
                return false;
            }
        }

        public async Task<bool> DeleteCourseAsync(int id)
        {
            try
            {
                var course = await _context.Courses.FindAsync(id);
                if (course != null)
                {
                    _context.Courses.Remove(course);
                    await _context.SaveChangesAsync();
                    return true;
                }
                return false;
            }
            catch
            {
                return false;
            }
        }

        public async Task<bool> CourseExistsAsync(string courseCode)
        {
            return await _context.Courses
                .AnyAsync(c => c.CourseCode == courseCode);
        }
    }
}