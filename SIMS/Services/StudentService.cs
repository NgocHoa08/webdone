using SIMS.Interfaces;
using SIMS.Models;

namespace SIMS.Services
{
    public class StudentService
    {
        private readonly IStudentRepository _studentRepository;

        public StudentService(IStudentRepository studentRepository)
        {
            _studentRepository = studentRepository;
        }

        public async Task<IEnumerable<Student>> GetAllStudentsAsync()
        {
            return await _studentRepository.GetAllStudentsAsync();
        }

        public async Task<Student> GetStudentByIdAsync(int id)
        {
            return await _studentRepository.GetStudentByIdAsync(id);
        }

        public async Task<(bool success, string message)> AddStudentAsync(Student student)
        {
            // Kiểm tra mã sinh viên đã tồn tại chưa
            if (await _studentRepository.StudentCodeExistsAsync(student.StudentCode))
            {
                return (false, "Student code already exists!");
            }

            // Kiểm tra email đã tồn tại chưa
            if (await _studentRepository.EmailExistsAsync(student.Email))
            {
                return (false, "Email already exists!");
            }

            var result = await _studentRepository.AddStudentAsync(student);
            return result ? (true, "Student added successfully!") : (false, "Error adding student!");
        }

        public async Task<(bool success, string message)> UpdateStudentAsync(Student student)
        {
            var result = await _studentRepository.UpdateStudentAsync(student);
            return result ? (true, "Student updated successfully!") : (false, "Error updating student!");
        }

        public async Task<bool> DeleteStudentAsync(int id)
        {
            return await _studentRepository.DeleteStudentAsync(id);
        }

        public async Task<IEnumerable<Student>> SearchStudentsAsync(string searchTerm)
        {
            return await _studentRepository.SearchStudentsAsync(searchTerm);
        }
    }
}