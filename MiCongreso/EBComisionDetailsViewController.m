//

//  Copyright (c) 2013 Eduardo Blancas https://github.com/edublancas
//
//  MIT LICENSE
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.

#import "EBComisionDetailsViewController.h"

@interface EBComisionDetailsViewController ()

@end

@implementation EBComisionDetailsViewController

@synthesize comision;

-(void)didUpdateDetails{
    //NSLog(@"Details: %@", comision.details);
    
    //Organize table data
    NSMutableSet *sectionsSet = [[NSMutableSet alloc]init];
    
    for (NSDictionary *integrante in comision.details) {
        NSMutableString *key = [[integrante objectForKey:@"posicion"]mutableCopy];
        
        if ([key isEqualToString:@"PRESIDENTA"]) {
            [key setString:@"PRESIDENTE"];
        }
        
        if ([key isEqualToString:@"SECRETARIA"]) {
            [key setString:@"SECRETARIO"];
        }
        
        [sectionsSet addObject:key];
    }

    //NSLog(@"sections %@", sectionsSet);
    
    tableData = [[NSMutableDictionary alloc]init];
    
    for (NSString *sectionName in sectionsSet) {
        for (NSDictionary *dic in comision.details) {
            //Matches SECRETARIA, SECRETARIO
            NSString *prefix = [sectionName substringToIndex:sectionName.length-1];
            NSLog(@"Prefix: %@", prefix);
            
            if ([[dic objectForKey:@"posicion"]hasPrefix:prefix]) {
                NSMutableArray *dicsForSection = [tableData objectForKey:sectionName];
                if (dicsForSection) {
                    
                    [dicsForSection addObject:dic];
                }else{
                    NSMutableArray *dicsForSection = [[NSMutableArray alloc]init];
                    
                    [dicsForSection addObject:dic];
                    
                    [tableData setObject:dicsForSection forKey:sectionName];
                    
                }
            }
        }
    }
    
    NSLog(@"table data: %@", tableData);
    

    
    [self.tableView reloadData];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithComision:(EBComision *)c{
    self = [super init];
    if (self){
        self.comision = c;
        self.comision.delegate = self;
        self.navigationItem.title = self.comision.nombre;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.comision downloadDetails];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //Presidente
    if (section==0) {
        return 1;
    //Secretarios
    }else if(section==1){
        return [[tableData objectForKey:@"SECRETARIO"]count];
    }else{
        return [[tableData objectForKey:@"INTEGRANTE"]count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //Presidente
    if (indexPath.section==0) {
        NSDictionary *presidente =  [[tableData objectForKey:@"PRESIDENTE"]objectAtIndex:0];
        cell.textLabel.text = [presidente objectForKey:@"nombre"];
    }else if(indexPath.section==1){
        NSDictionary *secretario =  [[tableData objectForKey:@"SECRETARIO"]objectAtIndex:indexPath.row];
        cell.textLabel.text = [secretario objectForKey:@"nombre"];
    }else{
        NSDictionary *integrante =  [[tableData objectForKey:@"INTEGRANTE"]objectAtIndex:indexPath.row];
        cell.textLabel.text = [integrante objectForKey:@"nombre"];
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0 && [[tableData objectForKey:@"PRESIDENTE"]count])
        return @"Presidencia";
    else if (section==1 && [[tableData objectForKey:@"SECRETARIO"]count])
        return @"Secretaría";
    else if (section==2 && [[tableData objectForKey:@"INTEGRANTE"]count])
        return @"Integrantes";
    else
        return @"";
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *name;
    NSUInteger type;
    
    if (indexPath.section==0) {
        name = [[[tableData objectForKey:@"PRESIDENTE"]objectAtIndex:0]objectForKey:@"nombre"];
        type = [[[[tableData objectForKey:@"PRESIDENTE"]objectAtIndex:0]objectForKey:@"tipo"]integerValue];
    }else if(indexPath.section==1){
        name = [[[tableData objectForKey:@"SECRETARIO"]objectAtIndex:indexPath.row]objectForKey:@"nombre"];
        type = [[[[tableData objectForKey:@"SECRETARIO"]objectAtIndex:0]objectForKey:@"tipo"]integerValue];
    }else{
        name = [[[tableData objectForKey:@"INTEGRANTE"]objectAtIndex:indexPath.row]objectForKey:@"nombre"];
        type = [[[[tableData objectForKey:@"INTEGRANTE"]objectAtIndex:0]objectForKey:@"tipo"]integerValue];
    }
    
    NSLog(@"Show: %@ - %d", name, type);
    
    EBCongresista *c = [[EBCongresista alloc]initWithName:name andType:type];
    
    EBCongresistaDetailViewController *controller = [[EBCongresistaDetailViewController alloc]initWithStyle:UITableViewStyleGrouped];
    controller.congresista = c;
    [controller.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    [self.navigationController pushViewController:controller animated:YES];
}

@end
