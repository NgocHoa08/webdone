using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SIMS.Models
{
    [Table("Courses")]
    public class Course
    {
        [Key]
        public int CourseId { get; set; }

        [Required(ErrorMessage = "Course code is required")]
        [StringLength(20)]
        public string CourseCode { get; set; }

        [Required(ErrorMessage = "Course name is required")]
        [StringLength(200)]
        public string CourseName { get; set; }

        [StringLength(1000)]
        public string Description { get; set; }

        [Required]
        [Range(1, 10, ErrorMessage = "Credits must be between 1 and 10")]
        public int Credits { get; set; }

        [StringLength(100)]
        public string Instructor { get; set; }

        public DateTime CreatedDate { get; set; } = DateTime.Now;

        public DateTime? UpdatedDate { get; set; }

        public bool IsActive { get; set; } = true;
    }
}