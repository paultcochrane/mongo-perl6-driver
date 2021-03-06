#`{{
  Testing;
    DBRef
}}

use v6;
use Test;

use MongoDB;
use MongoDB::DBRef;

#-------------------------------------------------------------------------------
#
my MongoDB::Connection $connection .= new();
my MongoDB::Database $database = $connection.database('test');

# Create collection and insert data in it!
#
my MongoDB::Collection $collection = $database.collection('cl1');

for ^10 -> $c {
  $collection.insert( { idx => $c,
                        name => 'k' ~ Int(6.rand),
                        value => Int($c.rand)
                      }
                    );
}

my Hash $d1 = $collection.find_one({idx => 8});
say "D d1: $d1.perl";

#-------------------------------------------------------------------------------
#
my MongoDB::DBRef $dbr .= new(:id($d1<_id>));
isa_ok $dbr, 'MongoDB::DBRef';

my BSON::ObjectId $i = $dbr.doc();
is $i, $d1<_id>, 'Compare object id';

$dbr .= new( :id($d1<_id>), :collection($collection.name));
my Hash $h = $dbr.doc();
is $h<$ref>, $collection.name, 'Test collection name';

#-------------------------------------------------------------------------------
# Cleanup
#
$connection.database('test').drop;

done();
exit(0);
