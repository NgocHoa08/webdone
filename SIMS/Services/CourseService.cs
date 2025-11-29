using SIMS.Interfaces;
using SIMS.Models;

namespace SIMS.Services
{
    public class CourseService
    {
        private readonly ICourseRepository _courseRepository;

        public CourseService(ICourseRepository courseRepository)
        {
            _courseRepository = courseRepository;
        }

        public async Task<IEnumerable<Course>> GetAllCoursesAsync()
        {
            return await _courseRepository.GetAllCoursesAsync();
        }

        public async Task<Course> GetCourseByIdAsync(int id)
        {
            return await _courseRepository.GetCourseByIdAsync(id);
        }

        public async Task<bool> AddCourseAsync(Course course)
        {
            // Kiểm tra mã khóa học đã tồn tại chưa
            if (await _courseRepository.CourseExistsAsync(course.CourseCode))
            {
                return false;
            }
            return await _courseRepository.AddCourseAsync(course);
        }

        public async Task<bool> UpdateCourseAsync(Course course)
        {
            return await _courseRepository.UpdateCourseAsync(course);
        }

        public async Task<bool> DeleteCourseAsync(int id)
        {
            return await _courseRepository.DeleteCourseAsync(id);
        }
    }
}