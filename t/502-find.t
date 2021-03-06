#`{{
  Testing;
    collection.find()                   Query database
    collection.ensure_index()           Create indexes
    collection.get_indexes()            Get index info
    collection.drop_index()             Drop an index
    collection.drop_indexes()           Drop all indexes
    cursor.fetch()                      Fetch a document
    
    X::MongoDB::Collection              Catch exceptions
}}

BEGIN { @*INC.unshift( './t' ) }
use Test-support;

use v6;
use Test;
use MongoDB;

my MongoDB::Collection $collection = get-test-collection( 'test', 'testf');

for 1..10 -> $i, $j
{
  my %d = %( code1 => 'd' ~ $i, code2 => 'n' ~ (100 -$j));
  $collection.insert(%d);
}

#show-documents( $collection, {});
#show-documents( $collection, %(code1 => 'd1'));

my MongoDB::Cursor $cursor = $collection.find(%(code1 => 'd1'));
is $cursor.count, 1, 'There is one document';

# This should go well
#
$collection.ensure_index( %( code1 => 1),
                          %( name => 'testindex',
                             background => True
                           )
                        );

$cursor = $collection.get_indexes();
is $cursor.count, 2, "Two indexes found";
my $doc;
my @index-names;
while $doc = $cursor.fetch {
    @index-names.push($doc<name>);
}

ok any(@index-names) ~~ '_id_', 'Index name _id_ found';
ok any(@index-names) ~~ 'testindex', 'Index name testindex found';

# Now we kick it
#
if 1 {
  # Its an empty key specification, but will complain about 'no index
  # name'. This is because of ensure_index() not being able to generate
  # one from the key specification.
  #
  $collection.ensure_index(%());
  CATCH {
    when X::MongoDB::Collection {
       ok $_.message ~~ m/no \s+ index \s+ name \s+ specified/, 'No index name';
    }
  }
}

if 1 {
  # Now the name is specified, We can get a 'bad add index' error.
  #
  $collection.ensure_index( %(), %(name => 'testindex'));
  CATCH {
    when X::MongoDB::Collection {
       ok $_.message ~~ m/bad \s+ add \s+ index \s+ attempt/, 'Bad add index attempt';
    }
  }
}

# Drop the same index twice. We get a 'can't find index' error.
#
$doc = $collection.drop_index( %( code1 => 1));
if 1 {
  $doc = $collection.drop_index( %( code1 => 1));
  CATCH {
    when X::MongoDB::Collection {
      ok $_.message ~~ m/can\'t \s+ find \s+ index \s+ with \s+ key/, q/Can't find index/;
    }
  }
}

# Create index again and delete using the index name
#
$collection.ensure_index( %( code1 => 1),
                          %( name => 'testindex',
                             background => True
                           )
                        );
$doc = $collection.drop_index('testindex');
is $doc<ok>.Bool, True, 'Drop index ok';

# Drop all indexes
#
$doc = $collection.drop_indexes;
ok $doc<msg> ~~ m/non\-_id \s+ indexes \s+ dropped \s+ for \s+ collection/,
   'All non-_id indexes dropped'
   ;

#-------------------------------------------------------------------------------
# Cleanup and close
#
$collection.database.drop;

done();
exit(0);

#-------------------------------------------------------------------------------
# Check one document for its fields. Something like {code => 1, nofield => 0}
# use find_one()
#
sub check-document ( $criteria, %field-list, %projection = { })
{
  my %document = %($collection.find_one( $criteria, %projection));
  if +%document {
    for %field-list.keys -> $k {
      if %field-list{$k} {
        is %document{$k}:exists,
           True,
           "Key '$k' exists. Check using find_one()"
           ;
      }
      
      else {
        is %document{$k}:exists,
           False,
           "Key '$k' does not exist. Check using find_one()"
           ;
      }
    }
  }
}
