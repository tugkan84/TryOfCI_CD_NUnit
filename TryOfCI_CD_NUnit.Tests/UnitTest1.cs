using NUnit.Framework;
using TryOfCI_CD_NUnit.Services;
namespace Tests
{
    public class Tests
    {
        Ops ops;
        [SetUp]
        public void Setup()
        {
            ops = new Ops();
        }

        [Test]
        public void Test1()
        {
            var result = ops.Calculate();
            
            Assert.That(result,Is.EqualTo(9));
            
            Assert.Pass();
        }
    }
}