using SIMS.SimsDbContext.Entities;

namespace SIMS.Interfaces
{
    public interface IUserRepository
    {
        Task<Users?> GetUserByUsername(string username);
        Task<Users?> GetUserById(int id);

    }
}
