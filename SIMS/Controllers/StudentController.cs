using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SIMS.Models;
using SIMS.Services;

namespace SIMS.Controllers
{
    [Authorize]
    public class StudentController : Controller
    {
        private readonly StudentService _studentService;

        public StudentController(StudentService studentService)
        {
            _studentService = studentService;
        }

        // Xem danh sách sinh viên
        [Authorize(Roles = "Administrator, User, Manager")]
        [HttpGet]
        public async Task<IActionResult> Index(string searchTerm)
        {
            IEnumerable<Student> students;

            if (!string.IsNullOrWhiteSpace(searchTerm))
            {
                students = await _studentService.SearchStudentsAsync(searchTerm);
                ViewData["SearchTerm"] = searchTerm;
            }
            else
            {
                students = await _studentService.GetAllStudentsAsync();
            }

            return View(students);
        }

        // Form thêm sinh viên mới
        [Authorize(Roles = "Administrator")]
        [HttpGet]
        public IActionResult Add()
        {
            return View();
        }

        // Xử lý thêm sinh viên
        [Authorize(Roles = "Administrator")]
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Add(Student student)
        {
            if (ModelState.IsValid)
            {
                var (success, message) = await _studentService.AddStudentAsync(student);

                if (success)
                {
                    TempData["SuccessMessage"] = message;
                    return RedirectToAction("Index");
                }
                else
                {
                    if (message.Contains("Student code"))
                    {
                        ModelState.AddModelError("StudentCode", message);
                    }
                    else if (message.Contains("Email"))
                    {
                        ModelState.AddModelError("Email", message);
                    }
                    else
                    {
                        ModelState.AddModelError("", message);
                    }
                }
            }
            return View(student);
        }

        // Form sửa sinh viên
        [Authorize(Roles = "Administrator")]
        [HttpGet]
        public async Task<IActionResult> Edit(int id)
        {
            var student = await _studentService.GetStudentByIdAsync(id);
            if (student == null)
            {
                return NotFound();
            }
            return View(student);
        }

        // Xử lý sửa sinh viên
        [Authorize(Roles = "Administrator")]
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(Student student)
        {
            if (ModelState.IsValid)
            {
                var (success, message) = await _studentService.UpdateStudentAsync(student);

                if (success)
                {
                    TempData["SuccessMessage"] = message;
                    return RedirectToAction("Index");
                }
                else
                {
                    ModelState.AddModelError("", message);
                }
            }
            return View(student);
        }

        // Xác nhận xóa sinh viên
        [Authorize(Roles = "Administrator")]
        [HttpGet]
        public async Task<IActionResult> Delete(int id)
        {
            var student = await _studentService.GetStudentByIdAsync(id);
            if (student == null)
            {
                return NotFound();
            }
            return View(student);
        }

        // Xử lý xóa sinh viên
        [Authorize(Roles = "Administrator")]
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var result = await _studentService.DeleteStudentAsync(id);
            if (result)
            {
                TempData["SuccessMessage"] = "Student deleted successfully!";
            }
            else
            {
                TempData["ErrorMessage"] = "Error deleting student!";
            }
            return RedirectToAction("Index");
        }

        // Chi tiết sinh viên
        [Authorize(Roles = "Administrator, User, Manager")]
        [HttpGet]
        public async Task<IActionResult> Details(int id)
        {
            var student = await _studentService.GetStudentByIdAsync(id);
            if (student == null)
            {
                return NotFound();
            }
            return View(student);
        }
    }
}