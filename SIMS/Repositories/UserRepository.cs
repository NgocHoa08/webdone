using Microsoft.EntityFrameworkCore;
using SIMS.Interfaces;
using SIMS.SimsDbContext;
using SIMS.SimsDbContext.Entities;

namespace SIMS.Repositories
{
    public class UserRepository : IUserRepository
    {
        private readonly SimDbContext _context;
        public UserRepository(SimDbContext dbContext)
        {
            _context = dbContext;
        }
        public async Task<Users?> GetUserById(int id)
        {
            return await _context.User.FindAsync(id).AsTask();
        }

        public async Task<Users?> GetUserByUsername(string username)
        {
            return await _context.User.FirstOrDefaultAsync(u => u.Username == username);
        }
    }
}
