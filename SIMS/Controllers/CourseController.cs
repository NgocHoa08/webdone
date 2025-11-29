using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SIMS.Models;
using SIMS.Services;

namespace SIMS.Controllers
{
    [Authorize]
    public class CourseController : Controller
    {
        private readonly CourseService _courseService;

        public CourseController(CourseService courseService)
        {
            _courseService = courseService;
        }

        // Xem danh sách khóa học
        [Authorize(Roles = "Administrator, User, Manager")]
        [HttpGet]
        public async Task<IActionResult> Index()
        {
            var courses = await _courseService.GetAllCoursesAsync();
            return View(courses);
        }

        // Form thêm khóa học mới
        [Authorize(Roles = "Administrator")]
        [HttpGet]
        public IActionResult Add()
        {
            return View();
        }

        // Xử lý thêm khóa học
        [Authorize(Roles = "Administrator")]
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Add(Course course)
        {
            if (ModelState.IsValid)
            {
                var result = await _courseService.AddCourseAsync(course);
                if (result)
                {
                    TempData["SuccessMessage"] = "Course added successfully!";
                    return RedirectToAction("Index");
                }
                else
                {
                    ModelState.AddModelError("CourseCode", "Course code already exists!");
                }
            }
            return View(course);
        }

        // Form sửa khóa học
        [Authorize(Roles = "Administrator")]
        [HttpGet]
        public async Task<IActionResult> Edit(int id)
        {
            var course = await _courseService.GetCourseByIdAsync(id);
            if (course == null)
            {
                return NotFound();
            }
            return View(course);
        }

        // Xử lý sửa khóa học
        [Authorize(Roles = "Administrator")]
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(Course course)
        {
            if (ModelState.IsValid)
            {
                var result = await _courseService.UpdateCourseAsync(course);
                if (result)
                {
                    TempData["SuccessMessage"] = "Course updated successfully!";
                    return RedirectToAction("Index");
                }
                else
                {
                    ModelState.AddModelError("", "Error updating course!");
                }
            }
            return View(course);
        }

        // Xác nhận xóa khóa học
        [Authorize(Roles = "Administrator")]
        [HttpGet]
        public async Task<IActionResult> Delete(int id)
        {
            var course = await _courseService.GetCourseByIdAsync(id);
            if (course == null)
            {
                return NotFound();
            }
            return View(course);
        }

        // Xử lý xóa khóa học
        [Authorize(Roles = "Administrator")]
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var result = await _courseService.DeleteCourseAsync(id);
            if (result)
            {
                TempData["SuccessMessage"] = "Course deleted successfully!";
            }
            else
            {
                TempData["ErrorMessage"] = "Error deleting course!";
            }
            return RedirectToAction("Index");
        }

        // Chi tiết khóa học
        [Authorize(Roles = "Administrator, User, Manager")]
        [HttpGet]
        public async Task<IActionResult> Details(int id)
        {
            var course = await _courseService.GetCourseByIdAsync(id);
            if (course == null)
            {
                return NotFound();
            }
            return View(course);
        }
    }
}