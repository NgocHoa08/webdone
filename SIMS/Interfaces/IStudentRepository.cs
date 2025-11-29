using SIMS.Models;

namespace SIMS.Interfaces
{
    public interface IStudentRepository
    {
        Task<IEnumerable<Student>> GetAllStudentsAsync();
        Task<Student> GetStudentByIdAsync(int id);
        Task<bool> AddStudentAsync(Student student);
        Task<bool> UpdateStudentAsync(Student student);
        Task<bool> DeleteStudentAsync(int id);
        Task<bool> StudentCodeExistsAsync(string studentCode);
        Task<bool> EmailExistsAsync(string email);
        Task<IEnumerable<Student>> SearchStudentsAsync(string searchTerm);
    }
}